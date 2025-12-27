# System Configuration & Environment Setup

This document describes the system configuration and software dependencies
used to acquire data from the Intel RealSense camera and process it in MATLAB.

> **Remark**
> This project was originally developed in **2022**.
> The following configuration is provided as a **reference guideline**.
> Running the system today may require version adjustments and could result in compatibility errors.

---

## 1. Hardware Setup

- **Depth Camera**: Intel RealSense D435i
- **Connection**: USB 3.0
- **Host Machine**:
  - OS: Windows (tested environment)
  - CPU: x64 architecture
  - GPU: Not required

---

## 2. Software Components Overview

The data acquisition and processing pipeline consists of the following components:

Intel RealSense Camera



↓



RealSense SDK 2.0



↓



C++ Backend (SDK)



↓



MATLAB RealSense Wrapper



↓



MATLAB Image & Point Cloud Processing

---

## 3. Required Software & Libraries

### 3.1 Intel RealSense SDK 2.0

- Official SDK for accessing RGB, depth, and IMU data
- Provides:
  - Frame streaming
  - Depth-color alignment
  - Point cloud generation

**Installation Notes**
- Download from Intel RealSense official repository
- Ensure camera firmware is updated
- SDK must be installed **before** MATLAB integration

---

### 3.2 CMake

- Required for building RealSense SDK components
- Used to compile native dependencies

**Recommended Version (2022)**
- CMake ≥ 3.18

---

### 3.3 MATLAB

- MATLAB with the following toolboxes:
  - Image Processing Toolbox
  - Computer Vision Toolbox

- MATLAB RealSense wrapper is required to:
  - Access camera frames
  - Retrieve depth and point cloud data

---

## 4. MATLAB–RealSense Integration Flow

---

## 5. Known Limitations

- This configuration reflects the system state in 2022
- SDK, MATLAB, or OS updates may introduce:
  - API changes
  - Build errors
  - Device permission issues

> This document serves as a **conceptual reference**, not a guaranteed step-by-step installation guide.
