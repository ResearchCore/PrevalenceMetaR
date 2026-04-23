# PrevalenceMetaR

This repository accompanies the article *“Conducting Meta-Analysis of Single Proportions Using R: A Practical Tutorial for Behavioral Researchers.”* It provides a fully annotated R script and a sample CSV dataset to facilitate meta-analysis of prevalence using the `meta` package with the Generalized Linear Mixed Model (GLMM) approach.

The workflow demonstrates:
- Estimation of pooled prevalence using random-effects models  
- Subgroup analysis  
- Sensitivity analysis  
- Meta-regression  
- Assessment of publication bias (funnel plot, Doi plot, LFK index, and statistical tests)  
- Additional graphical diagnostics (Baujat plot, Trim-and-Fill plot, and Galbraith plot)

Users can directly run the provided script with the sample dataset or adapt it to their own data by modifying variable names and input structure as needed.

---

## 📦 Software and Package Versions

All analyses were conducted using the following software environment:

- **R:** version 4.5.3  
- **RStudio:** version 2026.01.2+418 (“Apple Blossom”)  
- **meta package:** version 8.3  
- **metasens package:** version 1.5  

---

## 📁 Repository Contents

- `meta_analysis_script.R` → Fully annotated R script for all analyses  
- `meta_analysis_data.csv` → Sample dataset used in the tutorial  
- Output files (plots and results) → Generated during analysis  

---

## 🔁 Reproducibility

The script is designed to be fully reproducible. Minor variations in output or formatting may occur depending on:
- Operating system (Windows, macOS, Linux)  
- R or package version differences  

---

## 🧩 Notes

- The script uses the **GLMM approach**, which is recommended for meta-analysis of proportions.  
- Users unfamiliar with R are encouraged to follow the step-by-step workflow described in the accompanying article.  

---

## 📄 Related Article

For detailed explanations and interpretation of outputs, please refer to the associated manuscript.

---

## ⚠️ Disclaimer

This repository is intended for educational and research purposes. Users should ensure appropriate methodological decisions when applying the workflow to their own data.
