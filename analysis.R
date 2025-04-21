# MarcosMaio_RM12345_fase2_cap9

required_packages <- c("readxl", "ggplot2")
invisible(
  lapply(required_packages, function(pkg) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg, repos = "https://cloud.r-project.org")
    }
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  })
)

file_path <- ifelse(length(commandArgs(trailingOnly = TRUE)) >= 1,
                    commandArgs(trailingOnly = TRUE)[1],
                    "data_to_read/data.xlsx")
if (!file.exists(file_path)) stop("File not found: ", file_path)

df <- tryCatch(
  readxl::read_excel(file_path),
  error = function(e) stop("Failed to read ", file_path, ": ", e$message)
)

if (!"Production" %in% names(df)) stop("Column 'Production' not found in ", file_path)

df$Production <- as.numeric(gsub("[^0-9.]", "", as.character(df$Production)))
if (all(is.na(df$Production))) stop("Conversion of 'Production' resulted in all NA values")

x <- df$Production

stats <- list(
  mean      = mean(x, na.rm = TRUE),
  median    = median(x, na.rm = TRUE),
  mode      = as.numeric(names(which.max(table(x)))),
  range     = diff(range(x, na.rm = TRUE)),
  variance  = var(x, na.rm = TRUE),
  sd        = sd(x, na.rm = TRUE),
  cv        = sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE),
  quartiles = quantile(x, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
)

skew_desc       <- if (stats$mean > stats$median) "positive" else "negative"
dispersion_desc <- if (stats$cv < 0.3) "low dispersion" else if (stats$cv < 0.6) "moderate dispersion" else "high dispersion"
summary_text    <- sprintf(
  "Average production: %.0f t, median: %.0f t, %s skewness. CV: %.3f (%s). Quartiles: Q1=%.0f, Q2=%.0f, Q3=%.0f.",
  stats$mean, stats$median, skew_desc,
  stats$cv, dispersion_desc,
  stats$quartiles[1], stats$quartiles[2], stats$quartiles[3]
)

output_dir <- "data_analysis"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

sink(file.path(output_dir, "agro_statistics.txt"))

cat(
  "=== Production Statistics (t) ===\n",
  sprintf("Mean:                   %.0f\n", stats$mean),
  sprintf("Median:                 %.0f\n", stats$median),
  sprintf("Mode:                   %.0f\n\n", stats$mode),
  sprintf("Range:                  %.0f\n", stats$range),
  sprintf("Variance:               %.0f\n", stats$variance),
  sprintf("Standard deviation:     %.0f\n", stats$sd),
  sprintf("Coefficient of variation: %.3f\n\n", stats$cv),
  sprintf("Quartiles (25%%,50%%,75%%): %s\n\n", paste(round(stats$quartiles, 0), collapse = " / ")),
  "=== Summary ===\n",
  summary_text, "\n",
  sep = ""
)
sink()

invisible(pdf(file.path(output_dir, "agro_statistics.pdf"), width = 8, height = 6, onefile = TRUE))

print(
  ggplot(df, aes(x = Production)) +
    geom_histogram(bins = 10, color = "black", fill = NA) +
    geom_density(alpha = 0.2) +
    labs(
      title = "Histogram and Density of Production (t)",
      x     = "Production (t)",
      y     = "Frequency"
    )
)

print(
  ggplot(df, aes(y = Production)) +
    geom_boxplot() +
    labs(
      title = "Boxplot of Production (t)",
      y     = "Production (t)"
    )
)

print(
  ggplot(df, aes(sample = Production)) +
    stat_qq() +
    stat_qq_line() +
    labs(
      title = "QQ-Plot of Production (t)",
      x     = "Theoretical Quantiles",
      y     = "Observed Quantiles"
    )
)

print(
  ggplot(df, aes(x = Production)) +
    geom_density() +
    labs(
      title = "Density Plot of Production (t)",
      x     = "Production (t)",
      y     = "Density"
    )
)

invisible(dev.off())
