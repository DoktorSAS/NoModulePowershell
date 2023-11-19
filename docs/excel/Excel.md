# Excel.ps1 Function Documentation

The Excel.ps1 file in the NoModulePowershell library presents a comprehensive collection of PowerShell functions meticulously crafted to facilitate and streamline interactions with Excel files. This suite of functions is ingeniously designed to cater to a broad spectrum of Excel-related tasks, providing a robust, user-friendly toolkit for automating and managing Excel data.

## List of Functions

1. [Create-ExcelFile](#create-excelfile)
2. [Get-ExcelRowCount](#get-excelrowcount)
3. [Get-ExcelColumnCount](#Get-ExcelColumnCount)
4. [Get-ExcelCellValue](#Get-ExcelCellValue)
5. [Set-ExcelCellValue](#Set-ExcelCellValue)
6. [Get-ExcelRowData](#Get-ExcelRowData)
7. [Get-ExcelColumnData](#Get-ExcelColumnData)
8. [Set-ExcelRowData](#Set-ExcelRowData)
9. [Set-ExcelColumnData](#Set-ExcelColumnData)

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

```powershell
$filePath = "C:\Path\To\Your"
$fileName = "MyExcelFile"
$headers = @("Name", "Age", "City")
Create-ExcelFile -filePath $filePath -fileName $fileName -headers $headers
```

To create an empty Excel file with a unique name:

```powershell
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

```powershell
$rowCount = Get-ExcelRowCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of rows: $rowCount"
```

To get the row count excluding the header:

```powershell
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

```powershell
$columnCount = Get-ExcelColumnCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of columns: $columnCount"
```

To get the column count excluding the first column:

```powershell
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

```powershell
$value = Get-ExcelCellValue -filePath "C:\Path\To\Your\Excel\File.xlsx" -rowIndex 2 -columnIndex 'B'
Write-Host "Cell value: $value"
```

---

## Set-ExcelCellValue

Sets the value of a specified cell in an Excel worksheet. The function allows specifying the cell by row and column, where the column can be indicated using either its alphabetical letter or numerical index. It's important to note that both row and column indices start from 1.

| Argument    | Type   | Mandatory | Description                                                  | Example Value                                      |
|-------------|--------|-----------|--------------------------------------------------------------|----------------------------------------------------|
| filePath    | string | Yes       | The path of the Excel file                                   | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| rowIndex    | int    | Yes       | The index of the row (starting from 1)                       | `2`                                                |
| columnIndex | object | Yes       | The index (starting from 1) or letter of the column          | `2` or `'B'`                                       |
| value       | object | Yes       | The value to set in the specified cell                       | `"New Value"`                                      |

Usage:

To set the value in cell at row 2, column B:

```powershell
Set-ExcelCellValue -filePath "C:\Path\To\Your\Excel\File.xlsx" -rowIndex 2 -columnIndex 'B' -value "New Value"
```

---

## Get-ExcelRowData

Retrieves the data of a specified row in an Excel file as a hashtable. This function matches the data with headers in the first row, providing a convenient way to access cell data by header names.

| Argument    | Type   | Mandatory | Description                                   | Example Value                                      |
|-------------|--------|-----------|-----------------------------------------------|----------------------------------------------------|
| filePath    | string | Yes       | The path of the Excel file                    | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| rowIndex    | int    | Yes       | The index of the row for data retrieval       | `3`                                                |
| matchHeader | switch | No        | Matches data with headers in the first row    | `-matchHeader`                                     |

Usage:

To retrieve and print the data from row 3 of the Excel file, matching with headers in the first row:

```powershell
$excelFilePath = "C:\Path\To\Your\Excel\File.xlsx"
$rowIndex = 3
$rowData = Get-ExcelRowData -filePath $excelFilePath -rowIndex $rowIndex -matchHeader

foreach ($key in $rowData.Keys) {
    Write-Host "$key: $($rowData[$key])"
}
```

This example retrieves the data from row 3 of the Excel file and prints each cell's header and value.

---

## Get-ExcelColumnData

Retrieves the data of a specified column in an Excel file as a hashtable. This function matches the data with headers in the first column, providing a convenient way to access cell data by column headers.

| Argument         | Type   | Mandatory | Description                                   | Example Value                                      |
|------------------|--------|-----------|-----------------------------------------------|----------------------------------------------------|
| filePath         | string | Yes       | The path of the Excel file                    | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| columnIndex      | int    | Yes       | The index of the column for data retrieval    | `2`                                                |
| matchFirstColumn | switch | No        | Matches data with headers in the first column | `-matchFirstColumn`                                |

Usage:

To retrieve and print the data from column 2 of the Excel file, matching with headers in the first column:

```powershell
$excelFilePath = "C:\Path\To\Your\Excel\File.xlsx"
$columnIndex = 2
$columnData = Get-ExcelColumnData -filePath $excelFilePath -columnIndex $columnIndex -matchFirstColumn

foreach ($key in $columnData.Keys) {
    Write-Host "$key: $($columnData[$key])"
}
```

This example retrieves the data from column 2 of the Excel file and prints each cell's header and value.

---

## Set-ExcelRowData

Sets data in a specified row of an Excel file. This function allows values to be set in a row, starting from a specified column, which can be given either as a numerical index or as a letter. If the starting column is not specified, the function begins from the first empty column in the row.

| Argument         | Type     | Mandatory | Description                                                  | Example Value                                      |
|------------------|----------|-----------|--------------------------------------------------------------|----------------------------------------------------|
| filePath         | string   | Yes       | The path of the Excel file                                   | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| rowIndex         | int      | Yes       | The index of the row where data will be set                  | `3`                                                |
| values           | object[] | Yes       | An array of values to be set in the row                      | `@("Data1", "Data2", "Data3")`                     |
| startColumnIndex | object   | No        | The index or letter of the starting column. If not specified, starts from the first empty column | `2` or `'B'`                                       |

Usage:

To set data in row 3 of the Excel file, starting from column B:

```powershell
$filePath = "C:\Path\To\Your\Excel\File.xlsx"
$rowIndex = 3
$values = @("Data1", "Data2", "Data3")
Set-ExcelRowData -filePath $filePath -rowIndex $rowIndex -values $values -startColumnIndex 'B'
```

---

## Set-ExcelColumnData

Sets data in a specified column of an Excel file. This function allows values to be set in a column, starting from a specified row. The column is specified using its numerical index.

| Argument        | Type     | Mandatory | Description                                                    | Example Value                                      |
|-----------------|----------|-----------|----------------------------------------------------------------|----------------------------------------------------|
| filePath        | string   | Yes       | The path of the Excel file                                     | `'C:\Path\To\Your\Excel\File.xlsx'`                |
| columnIndex     | int      | Yes       | The index of the column where data will be set                 | `2`                                                |
| values          | object[] | Yes       | An array of values to be set in the column                     | `@("Data1", "Data2", "Data3")`                     |
| startRowIndex   | int      | No        | The index of the row from which to start setting the values. Defaults to the first row if not specified | `1` |

Usage:

To set data in column 2 of the Excel file, starting from row 1:

```powershell
$filePath = "C:\Path\To\Your\Excel\File.xlsx"
$columnIndex = 2
$values = @("Data1", "Data2", "Data3")
Set-ExcelColumnData -filePath $filePath -columnIndex $columnIndex -values $values -startRowIndex 1
```


---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>