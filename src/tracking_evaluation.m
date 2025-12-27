%% ===================== TRACKING DATA EVALUATION =====================
% This section evaluates the tracking performance using the recorded
% 3D trajectory data (X2, Y2, Z2) obtained from the RealSense pipeline.
% The evaluation includes trajectory smoothing, spatial amplitude analysis,
% error comparison with ideal and model trajectories, and efficiency metrics.

% Fitted the curve
% Smooth raw tracking data to reduce sensor noise and jitter
Xs2 = smooth(X2); 
Ys2 = smooth(Y2); 
Zs2 = smooth(Z2);

% Minimum Coordinate
% Extract minimum tracked position along each axis
minx2 = min(X2); 
miny2 = min(Y2); 
minz2 = min(Z2);

% Maximum coordinate
% Extract maximum tracked position along each axis
maxx2 = max(X2); 
maxy2 = max(Y2); 
maxz2 = max(Z2);

% Tracking max-min coordinate difference
% Calculate peak-to-peak displacement (converted from meters to millimeters)
diffx2 = (maxx2 - minx2)*1000;
diffy2 = (maxy2 - miny2)*1000;
diffz2 = (maxz2 - minz2)*1000;

% Ideal max-min coordinate difference
% Reference trajectory amplitude (ground truth / expected motion)
Ix = 8.200; 
Iy = 8.7000; 
Iz = 0.6000;

% Model max-min coordinate difference
% Model-based expected trajectory amplitude
Mx = 8.306; 
My = 8.7319; 
Mz = 2.4600;

% Error respect to ideal trajectory
% Compute deviation between measured tracking and ideal trajectory
errorxi2 = diffx2 - Ix;
erroryi2 = diffy2 - Iy;
errorzi2 = diffz2 - Iz;

% Error respect to model trajectory
% Compute deviation between measured tracking and model trajectory
errorxm2 = diffx2 - Mx;
errorym2 = diffy2 - My;
errorzm2 = diffz2 - Mz;

% Tracking Efficiency
% Ratio of successful tracking frames to total processed frames
Teff = n/framecounts;

% Show Data
% Display tracking amplitude results
fprintf('Amplitude :.\n')
fprintf('Model 2 = (%d, %d, %d).\n',diffx2,diffy2,diffz2)

% Display error with respect to ideal trajectory
fprintf('Error w.r.t. ideal.\n')
fprintf('Model 2 = (%d, %d, %d).\n',errorxi2,erroryi2,errorzi2)

% Display error with respect to model trajectory
fprintf('Error w.r.t. model.\n')
fprintf('Model 2 = (%d, %d, %d).\n',errorxm2,errorym2,errorzm2)

% Display tracking efficiency metric
fprintf('Tracking Efficiency = %d.\n',Teff)

% Plot graph
% Visualize raw tracking data versus smoothed trajectory (X-axis)
plot(t,X2)
hold on
plot(t,Xs2)
title('X','FontSize',20)
xlabel("#Frame")
ylabel("X (m)")
legend("Pure Data","Fitted Data")
hold off