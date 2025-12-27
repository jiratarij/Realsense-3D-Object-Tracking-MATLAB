# 3D Object Tracking Using Intel RealSense D435i and MATLAB

---

## Overview

This project focuses on **3D object motion tracking** using an **Intel RealSense D435i** depth camera integrated with **MATLAB**.

The primary objective is to track an object’s motion in three-dimensional space by:
1. Acquiring RGB images from the RealSense camera
2. Mapping RGB data with depth information
3. Estimating the object’s 3D coordinates in real time

The tracked 3D position data is then evaluated against a **reference mechanism** that represents the actual object motion.

---

## Tracking and Evaluation Concept

The system performance is evaluated using two main approaches:

- **Amplitude Deviation Analysis**  
  Measures the deviation between the tracked motion amplitude and the reference (actual) amplitude, providing insight into tracking accuracy.

- **Tracking Success Rate (TSR)**  
  Quantifies the robustness of the tracking system by calculating the ratio of successfully tracked frames to the total number of frames.

To enhance interpretability, the measured tracking data is visualized and compared directly with the reference data.

---

## Scope of This Repository

- MATLAB-based implementation for RGB–Depth mapping and 3D tracking
- Quantitative evaluation of tracking accuracy and robustness
- Data visualization for comparison between measured and reference motion

> **Note**  
> This repository provides a high-level overview in the README.  
> Detailed system configuration, processing pipelines, and evaluation methodologies are documented separately in the `docs/` folder.

---

## Documentation

For detailed explanations, please refer to:
- `docs/configuration.md` – System setup and environment configuration
- `docs/processing_pipeline.md` – Tracking and processing workflow
- `docs/evaluation.md` – Performance evaluation metrics and analysis


> **Remark**
> This project was originally developed in **2022**.
> The following repository is provided as a **reference guideline**.
> Running the system today may require version adjustments and could result in compatibility errors.
