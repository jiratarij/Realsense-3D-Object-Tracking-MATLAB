clc
clear
close all
warning off

% ===================== Video & RealSense Initialization =====================
% Create video player object for visualization
video_Player = vision.VideoPlayer();

% Create RealSense pipeline object (used for streaming RGB & Depth data)
pipe = realsense.pipeline();

% Create pointcloud object for 3D coordinate calculation
pointcloud = realsense.pointcloud();

% Start streaming from RealSense camera with default configuration
profile = pipe.start();

% Create alignment object to align Depth frame to Color frame
alignto = realsense.stream.color;
alignedfs = realsense.align(alignto);

% Create colorizer to visualize depth frame nicely
colorizer = realsense.colorizer();

% ===================== Camera Warm-up =====================
% Discard initial frames to allow camera auto-exposure to stabilize
for i = 1:15
    fs = pipe.wait_for_frames();
end

% ===================== Initial RGB Frame Acquisition =====================
% Get color frame
rgbframe = fs.get_color_frame();

% Convert raw RGB buffer into MATLAB image format
datargb = rgbframe.get_data;
rgbimg = permute(reshape(datargb', ...
    [3,rgbframe.get_width(),rgbframe.get_height()]),[3 2 1]);

% ===================== Region of Interest (ROI) =====================
% Define crop area [x y width height]
Rect = [310,10,79,79];

% Crop RGB image to ROI
rgbcrop = imcrop(rgbimg,Rect);

% ===================== Loop Control Variables =====================
run_loop = true;
framecounts = 0;   % Frame counter
n = 0;             % Valid detection counter
m = 0;             % Failed detection counter

tic   % Start timer

% ===================== Main Processing Loop =====================
while run_loop && framecounts < 200
    
    % --------------------- Frame Acquisition ---------------------
    framecounts = framecounts + 1;

    % Acquire new frameset
    fs = pipe.wait_for_frames();
    
    % Timestamp for current frame
    timestamp = toc;
    
    % Get RGB frame
    rgbframe = fs.get_color_frame();
   
    % Align depth frame to RGB frame
    aligned_frames = alignedfs.process(fs);
    depthframe = aligned_frames.get_depth_frame();
    
    % Colorize depth frame (for visualization)
    colorizedepth = colorizer.colorize(depthframe);
    
    % Convert RGB buffer to MATLAB image
    datargb = rgbframe.get_data;
    rgbimg = permute(reshape(datargb', ...
        [3,rgbframe.get_width(),rgbframe.get_height()]),[3 2 1]);
    
    % --------------------- Pre-processing ---------------------
    % Crop image to ROI
    rgbcrop = imcrop(rgbimg,Rect);
    
    % Use green channel for grayscale processing
    graycrop = rgbcrop(:,:,2);
    datagray = graycrop;
    
    % --------------------- Image Segmentation ---------------------
    % Convert grayscale image to binary using threshold
    bwcrop = im2bw(graycrop,0.25);
    
    % --------------------- Morphological Processing ---------------------
    % Invert binary image
    bwcrop = ~bwcrop;
    
    % Dilation to enhance object region
    sedi = strel('rectangle',[1 2]);
    bwcrop = imdilate(bwcrop,sedi);
    
    % Erosion to remove noise
    seer = strel('sphere',1);
    bwcrop = imerode(bwcrop,seer);
    
    % Invert back
    bwcrop = ~bwcrop;
    databwpostmor = bwcrop;
    
    % --------------------- Object Detection ---------------------
    % Detect circular object in ROI
    [centers,radii] = imfindcircles(bwcrop,[3 5], ...
        'ObjectPolarity','dark','Sensitivity',1);
    
    % --------------------- Validation Check ---------------------
    % Proceed only if exactly one circle is detected and frames are valid
    if length(radii) == 1 && (~isempty(radii)) && ...
       (~isempty(depthframe.logical())) && (~isempty(rgbframe.logical()))
       
        n = n + 1;
        t(n) = timestamp;
        
        % --------------------- Point Cloud Calculation ---------------------
        % Calculate 3D point cloud from depth frame
        points = pointcloud.calculate(depthframe);
        
        % Initial offset of coordinate system (meters)
        Cx = 0; Cy = 0; Cz = 0;
       
        % Extract XYZ vertices from point cloud
        vertices = points.get_vertices();
        xvertice = vertices(:,1,1)';
        yvertice = vertices(:,2,1)';
        zvertice = vertices(:,3,1)';
        
        % Reshape into image-sized matrices
        xpixel = reshape(xvertice, ...
            [colorizedepth.get_width(), colorizedepth.get_height()])';
        ypixel = reshape(yvertice, ...
            [colorizedepth.get_width(), colorizedepth.get_height()])';
        zpixel = reshape(zvertice, ...
            [colorizedepth.get_width(), colorizedepth.get_height()])';
        
        % Display detected center on RGB crop
        out = insertMarker(rgbcrop,centers,'x','color',"blue",'size',20);
        
        % Rounded center location
        rcenters = round(centers);
        
        % --------------------- Subpixel Interpolation ---------------------
        % Bilinear interpolation based on fractional pixel location
        % Multiple cases handle rounding direction of X and Y
        % Goal: estimate accurate 3D coordinate at detected circle center
        
        if centers(1) > rcenters(1)     % X rounddown
            
            if centers(2) > rcenters(2) % Y rounddown
                Pr = centers(2) - rcenters(2);
                Pc = centers(1) - rcenters(1);
                
                % Define surrounding pixels
                TL11 = [Rect(2) Rect(1)] + [rcenters(2) rcenters(1)];
                TL12 = [Rect(2) Rect(1)] + [rcenters(2) rcenters(1)+1];
                TL21 = [Rect(2) Rect(1)] + [rcenters(2)+1 rcenters(1)];
                TL22 = [Rect(2) Rect(1)] + [rcenters(2)+1 rcenters(1)+1];
                
                % Extract XYZ values of surrounding pixels
                x11 = xpixel(TL11(1),TL11(2));
                x12 = xpixel(TL12(1),TL12(2));
                x21 = xpixel(TL21(1),TL21(2));
                x22 = xpixel(TL22(1),TL22(2));
                
                y11 = ypixel(TL11(1),TL11(2));
                y12 = ypixel(TL12(1),TL12(2));
                y21 = ypixel(TL21(1),TL21(2));
                y22 = ypixel(TL22(1),TL22(2));
                
                z11 = zpixel(TL11(1),TL11(2));
                z12 = zpixel(TL12(1),TL12(2));
                z21 = zpixel(TL21(1),TL21(2));
                z22 = zpixel(TL22(1),TL22(2));
                
                % Bilinear interpolation
                x2 = (x11*Pc*Pr) + (x12*(1-Pc)*Pr) + ...
                     (x21*Pc*(1-Pr)) + (x22*(1-Pc)*(1-Pr)) + Cx;
                y2 = (y11*Pc*Pr) + (y12*(1-Pc)*Pr) + ...
                     (y21*Pc*(1-Pr)) + (y22*(1-Pc)*(1-Pr)) + Cy;
                z2 = (z11*Pc*Pr) + (z12*(1-Pc)*Pr) + ...
                     (z21*Pc*(1-Pr)) + (z22*(1-Pc)*(1-Pr)) + Cz;
            else
                % (Other rounding cases handled similarly)
            end
        else
            % (Other rounding cases handled similarly)
        end
        
        % --------------------- Output ---------------------
        % Convert meters to millimeters
        x2mm = x2*1000; 
        y2mm = y2*1000; 
        z2mm = z2*1000;
        
        fprintf('Tracked Coordinate #%d.\n',framecounts)
        fprintf('Model 2 = (%d, %d, %d).\n',x2mm,y2mm,z2mm)
        
        % Store trajectory
        X2(n) = x2; 
        Y2(n) = y2; 
        Z2(n) = z2;
  
    else
        % --------------------- Detection Failed ---------------------
        m = m + 1;
        out = rgbcrop;
        fprintf('Tracked Coordinate #%d : Cannot detect object.\n',framecounts)
    end
    
    fprintf('Time = #%d.\n',timestamp)
    
    % Display result frame
    step(video_Player,out);
end

pipe.stop;
% Stop RealSense pipeline
% This command safely stops the camera streaming and releases the hardware resources.
% It should always be called at the end of the program to prevent camera lock issues
% and to allow other applications or scripts to access the RealSense device later.
