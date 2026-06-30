```markdown
# Statistical Analysis of the Awareness and Utilization of Counselling Services among Students at the University of Dar es Salaam

## Overview

This repository contains the materials for our final year research project submitted in partial fulfilment of the requirements for the award of the **Bachelor of Science in Mathematical Statistics (BSMST)** at the **University of Dar es Salaam**.

The study investigates the level of awareness and utilization of counselling services among university students and identifies factors associated with their utilization using statistical methods.

---

## Research Objectives

The objectives of this study were to:

1. Determine the relationship between awareness and utilization of counselling services.
2. Assess differences in awareness across demographic characteristics.
3. Examine the influence of students' perceptions on the utilization of counselling services.

---

## Methodology

- **Research Design:** Cross-sectional quantitative study
- **Study Area:** University of Dar es Salaam
- **Sampling Technique:** Convenience Sampling
- **Data Collection Tool:** Structured Questionnaire
- **Software Used:** R (Version 4.3+) and Microsoft Excel

---

## Statistical Techniques

The following statistical methods were used:

- Descriptive Statistics
  - Frequencies
  - Percentages
  - Means
  - Standard Deviations
- Chi-Square Test of Independence
- Independent Samples t-test
- One-Way ANOVA
- Binary Logistic Regression

---

## Project Structure

```

.
├── data/
│   ├── raw_data.xlsx
│   └── cleaned_data.csv
│
├── scripts/
│   ├── data_cleaning.R
│   ├── descriptive_analysis.R
│   ├── inferential_analysis.R
│   └── visualization.R
│
├── output/
│   ├── tables/
│   ├── figures/
│   └── results/
│
├── dissertation.pdf
├── questionnaire.pdf
├── README.md
└── LICENSE

````

---

## Variables

### Dependent Variable

- Utilization of counselling services (Yes/No)

### Independent Variables

- Awareness score
- Gender
- Age group
- Year of study
- College
- Perceived confidentiality
- Accessibility
- Students' perceptions

---

## Required R Packages

```r
install.packages(c(
  "readxl",
  "dplyr",
  "tidyr",
  "ggplot2"
))
````

---

## Running the Analysis

1. Clone or download this repository.
2. Open the project in **RStudio**.
3. Place the dataset in the `data/` directory.
4. Run the scripts in the following order:

```
scripts/data_cleaning.R
scripts/descriptive_analysis.R
scripts/inferential_analysis.R
scripts/visualization.R
```

5. Tables and figures will be generated in the `output/` directory.

---

## Key Findings

* Most students were aware of the availability of counselling services.
* Utilization of counselling services was low.
* No statistically significant association was found between awareness and utilization.
* Gender and year of study were not significant predictors of awareness.
* Time constraints, preference for self-reliance, support from friends or family, and concerns about confidentiality were the major barriers to utilization.

---

## Authors

* **Victor Thadei Ngatunga**
* **Agatha Richard Magoge**
* **Abdallah Musa Mnemwa**

**Department of Mathematics**

**College of Natural and Applied Sciences**

**University of Dar es Salaam**

---

## Supervisor

**Dr. Rashid Mohammed**

Department of Mathematics

University of Dar es Salaam

---

## Citation

If you use this work, please cite it as:

> Ngatunga, V. T., Magoge, A. R., & Mnemwa, A. M. (2026). *Statistical Analysis of the Awareness and Utilization of Counselling Services among Students at the University of Dar es Salaam*. Bachelor of Science in Mathematical Statistics, University of Dar es Salaam.

---

## License

This project is intended for academic and educational purposes only.

© 2026 Victor Thadei Ngatunga, Agatha Richard Magoge, and Abdallah Musa Mnemwa. All rights reserved.

```
```

