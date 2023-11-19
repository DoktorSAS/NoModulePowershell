# Excel.ps1 Function Documentation

The Excel.ps1 file in the NoModulePowershell library presents a comprehensive collection of PowerShell functions meticulously crafted to facilitate and streamline interactions with Excel files. This suite of functions is ingeniously designed to cater to a broad spectrum of Excel-related tasks, providing a robust, user-friendly toolkit for automating and managing Excel data.

## List of Functions

1. [Create-ExcelFile](#create-excelfile)
2. [Get-ExcelRowCount](#get-excelrowcount)
3. [Get-ExcelColumnCount](#Get-ExcelColumnCount)
4. [Get-ExcelCellValue](#Get-ExcelCellValue)

---

## Create-ExcelFile

Creates a new Excel file at a specified location with optional headers and an optional unique filename. If headers are provided, they are set as the first row in the Excel file; otherwise, an empty Excel file is created. If the 'unique' switch is used, the file name will include a date and time to the millisecond to ensure uniqueness.

| Argument | Type     | Mandatory | Description                                                  | Example Value                           |
|----------|----------|-----------|--------------------------------------------------------------|-----------------------------------------|
| filePath | string   | Yes       | The path where the Excel file will be saved                  | `'C:\Path\To\Your'`                     |
| fileName | string   | Yes       | The name of the Excel file (without extension)               | `'MyExcelFile'`                         |
| headers  | string[] | No        | An array of header names to be included in the Excel file    | `@("Name", "Age", "City")`              |
| unique   | switch   | No        | If specified, appends a date and time to the file name to ensure it is unique | `-unique`                             |

Usage:

To create an Excel file with headers:

```ps
$filePath = "C:\Path\To\Your"
$fileName = "MyExcelFile"
$headers = @("Name", "Age", "City")
Create-ExcelFile -filePath $filePath -fileName $fileName -headers $headers
```

To create an empty Excel file with a unique name:

```ps
$filePath = "C:\Path\To\Your"
$fileName = "MyUniqueExcelFile"
Create-ExcelFile -filePath $filePath -fileName $fileName -unique
```

---

## Get-ExcelRowCount

Retrieves the row count of an Excel file. This function opens an Excel file and calculates the row count by counting non-empty cells in column A. In case of any errors (such as the file not being found), it returns -1.

| Argument       | Type   | Mandatory | Description                                     | Example Value                               |
|----------------|--------|-----------|-------------------------------------------------|---------------------------------------------|
| filePath       | string | Yes       | The path to the Excel file                      | `'C:\Path\To\Your\Excel\File.xlsx'`         |
| notIncludeHeader| switch | No        | Excludes the header row from the row count     | `-notIncludeHeader`                         |

Usage:

To get the row count of an Excel file:

```ps
$rowCount = Get-ExcelRowCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of rows: $rowCount"
```

To get the row count excluding the header:

```ps
$rowCount = Get-ExcelRowCount -filePath "C:\Path\To\Your\Excel\File.xlsx" -notIncludeHeader
Write-Host "Number of rows excluding header: $rowCount"
```

---

## Get-ExcelColumnCount

Calculates the number of columns in the first row of an Excel file. This function is useful for determining the column span of data within a worksheet. Optionally, it can exclude the first column from the count if it is used as a header or key column.

| Argument        | Type   | Mandatory | Description                                                  | Example Value                             |
|-----------------|--------|-----------|--------------------------------------------------------------|-------------------------------------------|
| filePath        | string | Yes       | The path to the Excel file                                    | `'C:\Path\To\Your\Excel\File.xlsx'`       |
| omitFirstColumn | switch | No        | Excludes the first column from the column count              | `-omitFirstColumn`                        |

Usage:

To get the column count of an Excel file:

```ps
$columnCount = Get-ExcelColumnCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of columns: $columnCount"
```

To get the column count excluding the first column:

```ps
$columnCount = Get-ExcelColumnCount -filePath "C:\Path\To\Your\Excel\File.xlsx" -omitFirstColumn
Write-Host "Number of columns excluding the first column: $columnCount"
```

---

## Get-ExcelCellValue

Retrieves the value from a specific cell in an Excel worksheet, identified by row and column indices. The column can be specified using either its alphabetical letter or numerical index. Note that both row and column indices start from 1.

| Argument    | Type   | Mandatory | Description                                                  | Example Value                                      |
|-------------|--------|-----------|--------------------------------------------------------------|----------------------------------------------------|
| filePath    | string | Yes       | The path of the Excel file                                   | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| rowIndex    | int    | Yes       | The index of the row (starting from 1)                       | `2`                                                |
| columnIndex | object | Yes       | The index (starting from 1) or letter of the column          | `2` or `'B'`                                       |

Usage:

To get the value from cell at row 2, column B:

```ps
$value = Get-ExcelCellValue -filePath "C:\Path\To\Your\Excel\File.xlsx" -rowIndex 2 -columnIndex 'B'
Write-Host "Cell value: $value"
```

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>