# Agro Data Analysis

## Overview

This project aims to perform a comprehensive exploratory analysis on agricultural data, specifically focused on crop production statistics. It involves transforming CSV data into an Excel format and subsequently performing statistical analyses and generating visual reports using R.

The analysis includes:

- **Measures of Central Tendency:** Mean, Median, and Mode
- **Measures of Dispersion:** Range, Variance, Standard Deviation, and Coefficient of Variation
- **Separating Measures:** Quartiles (Q1, Q2, Q3)
- **Graphical Analysis:** Histogram with Density Curve, Boxplot, QQ-Plot, and Density Plot

## Project Structure

```plaintext
project-root/
├── venv/
├── requirements.txt
├── app.py
├── data/
│   └── data.csv
├── data_to_read/
│   └── data.xlsx
├── data_analysis/
│   ├── agro_statistics.txt
│   └── agro_statistics.pdf
└── analysis.R
```

## Setup and Installation

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd <your-repo-directory>
```

### 2. Setup Python environment

Create a virtual environment and activate it:

```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
```

Install required Python packages:

```bash
pip install -r requirements.txt
```

### 3. Prepare data

Run the Python script to convert CSV data to XLSX:

```bash
python app.py
```

This will read the data from `data/data.csv` and generate an Excel file (`data.xlsx`) inside the `data_to_read` directory.

### 4. Run the R analysis

Ensure you have R installed on your system. Run the R script to perform the statistical analysis:

```bash
Rscript analysis.R
```

The script reads the Excel file, performs the analysis, and outputs results to the `data_analysis` directory.

## Outputs

After running the scripts, the following files are generated inside the `data_analysis` folder:

- `agro_statistics.txt`: Contains detailed statistical measures and a summary of findings.
- `agro_statistics.pdf`: Includes graphical analyses (histogram, boxplot, QQ-plot, and density plot).

## Dependencies

### Python
- openpyxl

### R
- readxl
- ggplot2

The required R packages are automatically installed by the script if they are not already present.

## Usage

The provided scripts allow easy and repeatable analysis:

- Place new CSV data into `data/data.csv`.
- Run `python app.py` to generate a new XLSX.
- Run `Rscript analysis.R` to perform the updated analysis.

## Conclusion

This structured approach facilitates efficient data conversion and comprehensive statistical analysis, providing meaningful insights into agricultural production data.