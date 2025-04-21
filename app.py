import os
import csv
from openpyxl import Workbook
from app.utils.csv_to_xlsx import csv_to_xlsx  

if __name__ == "__main__":
    input_csv = "data/data.csv"
    output_xlsx = os.path.join("data_to_read", "data.xlsx")
    csv_to_xlsx(input_csv, output_xlsx, sep=",")
