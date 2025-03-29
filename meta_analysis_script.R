#R Version 4.4.3; RStudio version version 2024.12.1 Build 563; Meta package version 8.0-2

#remove data of previous session
rm(list = ls())

# Install the necessary packages (if not installed)
install.packages("meta")

# Load the meta (and related) libraries
library(meta)

# Checking the working directory
getwd()

# Setting the working directory (update the folder path as per your system)
setwd("folder_path")
# Copy the folder path, paste it inside the quotes, and replace backslashes (\) with forward slashes (/).
# Alternatively, use the "Files" pane (bottom right in RStudio) to navigate to the folder
# and set the working directory via the "More" menu.

# Importing data from CSV file:
data <- read.csv(choose.files(), header = TRUE)
#This will open a pop-up window allowing the user to select and import the desired CSV file

# Running the meta-analysis using GLMM method
prev.meta.glmm <- metaprop(event = positive, n = total, data = data, 
                           studlab = study, pscale = 100, common = FALSE)
summary(prev.meta.glmm)

# Create and save the forest plot
pdf("forest.prev.meta.glmm.pdf", width = 10, height = 15)
forest(prev.meta.glmm, sortvar = study, common = FALSE)
dev.off()
#sortvar = study; To sort studies according to study/author names
#sortvar = -TE and sortvar = TE; To sort studies according to 
#descending or ascending order of effect sizes respectively

# Create and save the funnel plot
pdf("funnel.prev.meta.glmm.pdf", width = 15, height = 10)
par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)
funnel(prev.meta.glmm, xlab = "Logit Transformed Proportion",
       ylab = "Standard Error", cex = 2.5, lwd = 7)
dev.off()

# Test for publication bias using Begg & Mazumdar's Rank test
prev.meta.glmm.begs <- metabias(prev.meta.glmm, method.bias = "rank")
print(prev.meta.glmm.begs)

# Test for publication bias using Egger's test
prev.meta.glmm.egger <- metabias(prev.meta.glmm, method.bias = "linreg")
print(prev.meta.glmm.egger)

# Subgroup analysis by study site (e.g., community vs. hospital)
site.prev.meta.glmm <- update(prev.meta.glmm, subgroup = setting)
summary(site.prev.meta.glmm)
# Forest plot for subgroup analysis
pdf("forest.site.prev.meta.glm.pdf", width = 10, height = 15)
forest(site.prev.meta.glmm, sortvar = study, common = FALSE)
dev.off()

# analysis for prevalence in males
males.prev.meta.glmm <- update(prev.meta.glmm, subset = males == "y")
summary(males.prev.meta.glmm)
# Forest plot for Sensitivity analysis (males)
pdf("forest.males.prev.meta.glmm.pdf", width = 10, height = 15)
forest(males.prev.meta.glmm, sortvar = study, common = FALSE)
dev.off()

# Sensitivity analysis based on quality score
quality.prev.meta.glmm <- update(prev.meta.glmm, subset = quality >= 6)
summary(quality.prev.meta.glmm)
# Forest plot for Sensitivity analysis (quality score)
pdf("forest.quality.prev.meta.glmm.pdf", width = 10, height = 15)
forest(quality.prev.meta.glmm, sortvar = study, common = FALSE)
dev.off()

# Meta-regression by single variable (e.g., age)
agemr.prev.meta.glmm <- metareg(prev.meta.glmm, formula = age)
summary(agemr.prev.meta.glmm)

# Meta-regression by multiple variables (e.g., setting and age)
metareg.prev.meta.glmm <- metareg(prev.meta.glmm, formula = setting + age)
summary(metareg.prev.meta.glmm)

#Additional analyses

# Baujat Plot to detect studies contributing to heterogeneity:
pdf("Baujat.prev.meta.glmm.pdf", width = 15, height = 10)
par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)
baujat(prev.meta.glmm)
dev.off()

# Trim and fill method to correct funnel plot asymmetry:
tnf.prev.meta.glmm <- trimfill(prev.meta.glmm)
tnf.prev.meta.glmm
pdf("tnf.prev.meta.glmm.pdf", width = 15, height = 10)
par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)
funnel(tnf.prev.meta.glmm, xlab = "Logit Transformed Proportion", ylab = "Standard Error", cex = 2.5, lwd = 7)
dev.off()

# Galbraith's Radial plot to examine heterogeneity:
pdf("radial.prev.meta.glmm.pdf", width = 15, height = 10)
par(mar = c(7, 7, 2.1, 2.1), cex.lab = 2.5, cex.axis = 2.5)
radial(prev.meta.glmm, level = 0.95, cex = 2.5, lwd = 7)
dev.off()

