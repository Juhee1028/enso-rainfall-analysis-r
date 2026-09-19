# ENSO and Summer Rainfall Analysis in Brisbane

## Overview

This project investigates the relationship between the El Niño–Southern Oscillation (ENSO) and seasonal rainfall at Brisbane Airport.

Using R, I combined seasonal rainfall and Southern Oscillation Index (SOI) data, explored seasonal patterns, and compared several statistical models. The analysis focuses on whether SOI values and ENSO phases help explain variation in summer rainfall.

The results indicate that ENSO is significantly associated with summer rainfall. However, ENSO variables explain only a limited proportion of total rainfall variability, so the models are more useful for understanding relationships than for producing accurate rainfall forecasts.

## Research Questions

- How does seasonal SOI relate to total seasonal rainfall?
- In which season is the relationship strongest?
- Does a quadratic model describe summer rainfall better than a simple linear model?
- Do average rainfall levels differ between El Niño, Neutral, and La Niña phases?
- How reliable are SOI and ENSO phase as predictors of summer rainfall?

## Data

The analysis uses two datasets:

- `total_seasonal_rainfall.csv`
- `seasonal_soi_data.csv`

The datasets were joined using `Year` and `Season`. The analysis uses seasonal rainfall totals, mean seasonal SOI values, and ENSO phase classifications.

The summer subset contains 73 observations:

| ENSO phase | Observations |
|---|---:|
| El Niño | 13 |
| Neutral | 40 |
| La Niña | 20 |

The datasets were provided for academic analysis. Their use and redistribution remain subject to the terms of their original sources.

## Tools and Skills

- R
- tidyverse
- ggplot2
- broom
- Data cleaning and transformation
- Exploratory data analysis
- Linear and polynomial regression
- Model diagnostics
- ANOVA and multiple comparisons
- Categorical regression
- Chi-square goodness-of-fit testing

## Analysis Workflow

1. Imported and combined rainfall and SOI data
2. Selected relevant variables and handled missing values
3. Compared SOI–rainfall relationships across seasons
4. Selected summer for detailed analysis
5. Fitted simple linear and quadratic regression models
6. Evaluated residual normality, linearity, and variance assumptions
7. Compared rainfall across ENSO phases using ANOVA and Tukey tests
8. Fitted a categorical regression model
9. Examined ENSO phase frequencies using a chi-square test
10. Evaluated the statistical and physical limitations of the models

## Key Findings

### Seasonal relationship

Summer showed the strongest relationship between seasonal SOI and total rainfall.

The simple linear model estimated that summer rainfall increased by approximately **8.49 mm for each one-unit increase in SOI**.

- Slope estimate: `8.491`
- 95% confidence interval: `3.149 to 13.834`
- p-value: `0.00226`
- R-squared: `0.1239`

Although the relationship was statistically significant, SOI explained only approximately **12.39%** of the variation in summer rainfall.

### Linear and quadratic model comparison

A quadratic regression model provided a better fit than the simple linear model.

| Model | R-squared |
|---|---:|
| Simple linear regression | 0.1239 |
| Quadratic regression | 0.1883 |

A nested-model ANOVA found that adding the quadratic term significantly improved model fit:

- F-statistic: `5.5488`
- p-value: `0.0213`

The quadratic model suggests that rainfall may increase more rapidly under strongly positive SOI conditions. Nevertheless, most rainfall variability remains unexplained.

### Rainfall differences between ENSO phases

A one-way ANOVA found evidence that average summer rainfall differed between ENSO phases:

- F-statistic: `5.534`
- p-value: `0.00587`

Tukey multiple comparisons indicated that:

- La Niña rainfall was approximately `199.18 mm` higher than El Niño rainfall
- La Niña rainfall was approximately `182.74 mm` higher than Neutral rainfall
- Neutral and El Niño rainfall were not significantly different

A categorical regression produced a consistent result. Relative to Neutral conditions, La Niña was associated with approximately **182.74 mm more summer rainfall**.

### Model diagnostics

The diagnostic analysis identified several limitations:

- Residual plots indicated possible non-linearity
- Residuals showed some deviation from normality in the tails
- Rainfall variability was greater during La Niña conditions
- Bartlett’s test indicated unequal group variances
- Prediction intervals were wide at extreme SOI values
- One prediction interval included negative rainfall, which is not physically meaningful

These findings mean that statistical significance should not be interpreted as strong predictive performance.

## Conclusion

ENSO conditions are meaningfully associated with summer rainfall at Brisbane Airport. Positive SOI values and La Niña conditions were generally associated with higher rainfall.

The quadratic model fitted the observed relationship better than the simple linear model, but its explanatory power remained limited. ENSO is therefore useful for understanding part of the variation in summer rainfall, but it is not sufficient as a standalone forecasting variable.

Additional climate variables and robust modelling methods would be needed to improve predictive performance.

## Repository Structure

```text
enso-rainfall-analysis-r/
├── README.md
├── enso_rainfall_analysis.R
├── data/
│   ├── total_seasonal_rainfall.csv
│   └── seasonal_soi_data.csv
├── figures/
└── LICENSE
