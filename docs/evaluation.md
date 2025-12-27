# Tracking Evaluation Method

This document explains how tracking performance is evaluated using
`Evaluation.m`.



## 1. Evaluation Objectives

The evaluation focuses on:
- Amplitude Deviation Analysis
- Tracking Success Rate
- Trajectory Visualization



## 2. Trajectory Smoothing

- Raw tracking data (X, Y, Z) is smoothed
- Purpose:
  - Reduce noise
  - Highlight motion trend



## 3. Amplitude Deviation Analysis

- The amplitude deviation is used as a quantitative metric to evaluate the tracking performance.
- Amplitude Deviation in each axis are calculated as :

$$\text{Amplitude Deviation} = \text{Measured Amplitude} - \text{Reference Amplitude}$$



## 4. Tracking Success Rate

- The tracking success rate is used to evaluate the robustness of the proposed tracking system.
- Tracking Success Rate is defined as:

$$\text{Tracking Success Rate} = \frac{\text{Valid Tracking Frames}}{\text{Total Frames}}$$



## 5. Trajectory Visualization

- Raw and smoothed trajectories are plotted
- Enables qualitative assessment of tracking stability
