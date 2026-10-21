# survival-analysis-causal-inference

A modular demonstration of design-adjusted survival analysis, survey-weighted Cox proportional hazards modeling, and proportional hazards diagnostic testing using open-access health data.

## Overview

In population-based biostatistics and epidemiological cohorts, analyzing time-to-event outcomes requires accounting for both sampling design (weights, clustering, stratification) and non-informative censoring. Standard Unweighted Cox models produce artificially narrow confidence intervals and biased hazard ratio (HR) point estimates when oversampling is present.

This repository demonstrates:
- Kaplan-Meier survival curve estimation.
- Survey-weighted Cox Proportional Hazards modeling (`svycoxph`).
- Extraction of design-adjusted Hazard Ratios (HR) and 95% Confidence Intervals.
- Model diagnostics via Schoenfeld residuals for proportional hazards assumption verification.

## Dataset

Demonstrated using R's built-in primary biliary cholangitis (`pbc`) dataset from the `survival` package, extended with simulated survey weighting metadata to illustrate complex sampling integration.

## Usage

```R
# Install required packages
install.packages(c("survival", "survey", "broom", "ggplot2"))

# Run survival pipeline
source("01_survey_cox_survival_pipeline.R")
