# Excel.ps1 Function Documentation

The Excel.ps1 file in the NoModulePowershell library presents a comprehensive collection of PowerShell functions meticulously crafted to facilitate and streamline interactions with Excel files. This suite of functions is ingeniously designed to cater to a broad spectrum of Excel-related tasks, providing a robust, user-friendly toolkit for automating and managing Excel data.

## List of Functions

1. [Create-ExcelFile](#create-excelfile)

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

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>