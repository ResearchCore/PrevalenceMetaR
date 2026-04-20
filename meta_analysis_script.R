# ------------------------------------------------------------
# Meta-analysis of Prevalence using GLMM in R
# R version: 4.5.3
# RStudio version: 2026.01.2+418 ("Apple Blossom")
# meta package version: 8.3-0
# metasens package version: 1.5-3
# ------------------------------------------------------------

# Clear all objects from the current R session
rm(list = ls())

# ------------------------------------------------------------
# Install required packages (run once if not already installed)
# ------------------------------------------------------------
install.packages("meta")
install.packages("metasens")

# ------------------------------------------------------------
# Load required libraries
# ------------------------------------------------------------
library(meta)
library(grid)
library(metasens)

# ------------------------------------------------------------
# Set and verify working directory
# ------------------------------------------------------------

# Check the current working directory
getwd()

# Set the working directory (replace with your actual folder path)
setwd("folder_path")
# Tip:
# - Paste the folder path inside quotes.
# - Replace backslashes (\) with forward slashes (/). For example:
# - if folder path is- C:\Users\vikas\OneDrive\Documents\MetaR
# - setwd("C:/Users/vikas/OneDrive/Documents/MetaR")
# - Alternatively, use RStudio: Files pane → More → Set As Working Directory

# ------------------------------------------------------------
# Import data
# ------------------------------------------------------------

# Import data from a CSV file
data <- read.csv(choose.files(), header = TRUE)
# A file selection dialog will open to choose the CSV file

# View the imported dataset in tabular form
# This is useful for checking data structure and identifying errors
View(data)

# ------------------------------------------------------------
# Meta-analysis of prevalence using GLMM
# ------------------------------------------------------------

prev.meta.glmm <- metaprop(
  event   = positive,
  n       = total,
  data    = data,
  studlab = study,
  pscale  = 100,
  common  = FALSE,
  method  = "GLMM",
  prediction = TRUE
)

# Display summary results
summary(prev.meta.glmm)

# ------------------------------------------------------------
# Forest plot
# ------------------------------------------------------------

pdf("forest.prev.meta.glmm.pdf",
    width = 10,
    height = 15)

forest(prev.meta.glmm, sortvar = study, common  = FALSE)
# Note:
# - To avoid overlap, add:
#   calcwidth.tests = TRUE, calcwidth.hetstat = TRUE

grid.text(
  "Pooled Prevalence of Disease X",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# Sorting options for forest plots:
# sortvar = study     → sort by study/author name
# sortvar = TE        → ascending order of effect size
# sortvar = -TE       → descending order of effect size

# ------------------------------------------------------------
# Funnel plot
# ------------------------------------------------------------

pdf("funnel.prev.meta.glmm.pdf",
    width = 15,
    height = 10)

par(mar = c(7, 7, 2.1, 2.1),
    cex.lab = 2.5,
    cex.axis = 2.5)

funnel(
  prev.meta.glmm,
  xlab = "Logit Transformed Proportion",
  ylab = "Standard Error",
  cex  = 2.5,
  lwd  = 7
)

grid.text(
  "Funnel Plot",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Tests for publication bias
# ------------------------------------------------------------

# Begg & Mazumdar’s rank correlation test
prev.meta.glmm.begs <- metabias(prev.meta.glmm, method.bias = "rank")
print(prev.meta.glmm.begs)

# Egger’s regression test
prev.meta.glmm.egger <- metabias(prev.meta.glmm, method.bias = "linreg")
print(prev.meta.glmm.egger)

# ------------------------------------------------------------
# Doi plot
# ------------------------------------------------------------

pdf("doi.prev.meta.glmm.pdf",
    width = 15,
    height = 10)

par(mar = c(7, 7, 2.1, 2.1),
    cex.lab = 2,
    cex.axis = 2)

doiplot(prev.meta.glmm, main = "Doi Plot for Prevalence of Disease X")

dev.off()

# ------------------------------------------------------------
# LFK index test
# ------------------------------------------------------------

lfkindex.pre.meta.glmm <- lfkindex(prev.meta.glmm)
lfkindex.pre.meta.glmm

# ------------------------------------------------------------
# Subgroup analysis (e.g., study setting)
# ------------------------------------------------------------

site.prev.meta.glmm <- update(prev.meta.glmm, subgroup = setting)
summary(site.prev.meta.glmm)

pdf("forest.site.prev.meta.glm.pdf",
    width = 10,
    height = 15)

forest(
  site.prev.meta.glmm,
  sortvar = study,
  common  = FALSE,
  calcwidth.tests = TRUE
)

grid.text(
  "Subgroup Analysis: Study Setting",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Sensitivity analysis: prevalence in males
# ------------------------------------------------------------

males.prev.meta.glmm <- update(prev.meta.glmm, subset = males == "y")
summary(males.prev.meta.glmm)

pdf("forest.males.prev.meta.glmm.pdf",
    width = 10,
    height = 15)

forest(males.prev.meta.glmm, sortvar = study, common  = FALSE)

grid.text(
  "Pooled Prevalence in Males",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Sensitivity analysis based on study quality
# ------------------------------------------------------------

quality.prev.meta.glmm <- update(prev.meta.glmm, subset = quality >= 6)
summary(quality.prev.meta.glmm)

pdf("forest.quality.prev.meta.glmm.pdf",
    width = 10,
    height = 15)

forest(quality.prev.meta.glmm,
       sortvar = study,
       common  = FALSE)

grid.text(
  "Sensitivity Analysis: High-Quality Studies",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Meta-regression analyses
# ------------------------------------------------------------

# Meta-regression with a single covariate (e.g., age)
agemr.prev.meta.glmm <- metareg(prev.meta.glmm, formula = age)
summary(agemr.prev.meta.glmm)

# Meta-regression with multiple covariates (e.g., setting and age)
metareg.prev.meta.glmm <- metareg(prev.meta.glmm, formula = setting + age)
summary(metareg.prev.meta.glmm)

# ------------------------------------------------------------
# Baujat plot
# ------------------------------------------------------------

# Baujat plot to identify studies contributing to heterogeneity
pdf("Baujat.prev.meta.glmm.pdf", width = 15, height = 10)

par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)

baujat(prev.meta.glmm)

grid.text(
  "Baujat Plot",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Trim-and-fill method to adjust for publication bias
# ------------------------------------------------------------

tnf.prev.meta.glmm <- trimfill(prev.meta.glmm)
tnf.prev.meta.glmm

pdf("tnf.prev.meta.glmm.pdf", width = 15, height = 10)

par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)

funnel(
  tnf.prev.meta.glmm,
  xlab = "Logit Transformed Proportion",
  ylab = "Standard Error",
  cex  = 2.5,
  lwd  = 7
)

grid.text(
  "Trim-and-Fill Funnel Plot",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()

# ------------------------------------------------------------
# Galbraith (radial) plot to examine heterogeneity
# ------------------------------------------------------------

pdf("radial.prev.meta.glmm.pdf", width = 15, height = 10)

par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)

radial(
  prev.meta.glmm,
  level = 0.95,
  cex   = 2.5,
  lwd   = 7
)

grid.text(
  "Galbraith’s Radial Plot",
  y  = unit(0.98, "npc"),
  gp = gpar(fontsize = 16, fontface = "bold")
)

dev.off()
