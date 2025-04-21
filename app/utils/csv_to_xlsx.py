import csv
import logging
from pathlib import Path
from openpyxl import Workbook
from typing import Union

logger = logging.getLogger(__name__)

def csv_to_xlsx(
    csv_path: Union[str, Path],
    xlsx_path: Union[str, Path],
    sep: str = ",",
    sheet_name: str = "Sheet1",
    write_only: bool = True,
    encoding: str = "utf-8"
) -> Path:
    """
    Convert a CSV file to XLSX.

    Args:
        csv_path: Path to the source .csv file.
        xlsx_path: Path where the .xlsx will be written.
        sep: CSV delimiter (default: ',').
        sheet_name: Name of the Excel worksheet (default: 'Sheet1').
        write_only: If True, use openpyxl's write_only mode for large files.
        encoding: File encoding to read the CSV (default: 'utf-8').

    Returns:
        Path object pointing at the newly created .xlsx file.

    Raises:
        FileNotFoundError: If the CSV input does not exist.
        ValueError: If csv_path == xlsx_path.
        Exception: Passes through I/O or openpyxl errors.
    """
    csv_path = Path(csv_path)
    xlsx_path = Path(xlsx_path)

    if not csv_path.is_file():
        raise FileNotFoundError(f"CSV input not found: {csv_path}")
    if csv_path.resolve() == xlsx_path.resolve():
        raise ValueError("csv_path and xlsx_path must be different files")

    xlsx_path.parent.mkdir(parents=True, exist_ok=True)

    wb = Workbook(write_only=write_only)
    ws = wb.create_sheet(title=sheet_name)

    try:
        with csv_path.open(newline="", encoding=encoding) as f:
            reader = csv.reader(f, delimiter=sep)
            for row in reader:
                ws.append(row)
    except Exception as e:
        logger.exception("Failed reading CSV %s", csv_path)
        raise

    try:
        wb.save(str(xlsx_path))
        logger.info("Generated XLSX: %s", xlsx_path)
    except Exception as e:
        logger.exception("Failed writing XLSX %s", xlsx_path)
        raise

    return xlsx_path