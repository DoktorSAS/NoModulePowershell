<#
.SYNOPSIS
Creates a new Excel file with optional specified headers and an optional unique filename.

.DESCRIPTION
This function creates a new Excel file with the provided file path and file name. 
If provided, it sets the header row in the Excel file and formats every cell as text. 
If headers are not provided, it creates an empty Excel file.
If the 'unique' switch is used, the file name will include a date and time to the millisecond to ensure uniqueness.

.PARAMETER filePath
The path where the Excel file will be saved. This parameter is mandatory.

.PARAMETER fileName
The name of the Excel file (without extension). This parameter is mandatory.

.PARAMETER headers
An array of header names. This parameter is optional.

.PARAMETER unique
If specified, appends a date and time to the file name to ensure it is unique.

.EXAMPLE
$filePath = "C:\Path\To\Your"
$fileName = "MyExcelFile"
$headers = @("Name", "Age", "City")
Create-ExcelFile -filePath $filePath -fileName $fileName -headers $headers

.EXAMPLE
$filePath = "C:\Path\To\Your"
$fileName = "MyUniqueExcelFile"
Create-ExcelFile -filePath $filePath -fileName $fileName -unique
#>

function Create-ExcelFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [string]$fileName,

        [Parameter(Mandatory=$false)]
        [string[]]$headers,

        [Parameter(Mandatory=$false)]
        [switch]$unique
    )

    # Verify if the provided file path is valid
    if (-not (Test-Path -Path $filePath)) {
        Write-Error "Specified file path is not valid."
        return
    }

    # Append a date and time if the 'unique' switch is used
    if ($unique) {
        $dateTimePart = Get-Date -Format "yyyyMMdd-HHmmssfff"
        $fileName = "$fileName-$dateTimePart"
    }

    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Add()
    $worksheet = $workbook.Worksheets.Item(1)

    if ($headers) {
        # Set the header row
        for ($col = 1; $col -le $headers.Count; $col++) {
            $worksheet.Cells.Item(1, $col).Value2 = $headers[$col - 1]
            $worksheet.Cells.Item(1, $col).NumberFormat = "@"
        }
    }

    # Set the format of every cell to Text for all rows if headers are provided
    if ($headers) {
        $usedRange = $worksheet.UsedRange
        $usedRange.NumberFormat = "@"
    }

    $outputFileName = "$fileName.xlsx"
    $outputFilePath = Join-Path $filePath $outputFileName

    $workbook.SaveAs($outputFilePath)
    $excel.Quit()

    Write-Host "Excel file created: $outputFilePath"
    return $outputFilePath
}

<#
.SYNOPSIS
Gets the row count of an Excel file.

.DESCRIPTION
This function opens an Excel file, selects the appropriate worksheet (assuming it's the first one),
and calculates the row count by counting non-empty cells in column A.
Returns -1 in case of any errors (e.g., file not found).

.PARAMETER filePath
The path to the Excel file.

.PARAMETER notIncludeHeader
If specified, excludes the header row from the row count.

.EXAMPLE
# Get the row count of an Excel file
$rowCount = Get-ExcelRowCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of rows: $rowCount"
#>

function Get-ExcelRowCount {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$false)]
        [switch]$notIncludeHeader
    )

    try {
        # Create a new Excel application
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false

        # Open the Excel file
        $workbook = $excel.Workbooks.Open($filePath)

        # Select the appropriate worksheet (assuming it's the first one)
        $worksheet = $workbook.Sheets.Item(1)

        # Find the last used row in column A
        $lastRow = $worksheet.Cells($worksheet.Rows.Count, 1).End(-4162).Row

        # Exclude the header row if specified
        if ($notIncludeHeader) {
            $lastRow--
        }

        # Close Excel without saving changes
        $workbook.Close()
        $excel.Quit()
    } catch {
        Write-Host "An error occurred: $_"
        return -1
    } finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }

    return $lastRow
}

<#
.SYNOPSIS
Gets the column count of an Excel file.

.DESCRIPTION
This function opens an Excel file, selects the appropriate worksheet (assuming it's the first one),
and calculates the column count by counting non-empty cells in the first row.
Can optionally exclude the first column from the count.

.PARAMETER filePath
The path to the Excel file.

.PARAMETER omitFirstColumn
If specified, excludes the first column from the column count.

.EXAMPLE
# Get the column count of an Excel file
$columnCount = Get-ExcelColumnCount -filePath "C:\Path\To\Your\Excel\File.xlsx"
Write-Host "Number of columns: $columnCount"

.EXAMPLE
# Get the column count of an Excel file, excluding the first column
$columnCount = Get-ExcelColumnCount -filePath "C:\Path\To\Your\Excel\File.xlsx" -omitFirstColumn
Write-Host "Number of columns excluding the first column: $columnCount"
#>

function Get-ExcelColumnCount {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$false)]
        [switch]$omitFirstColumn
    )

    try {
        # Create a new Excel application
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false

        # Open the Excel file
        $workbook = $excel.Workbooks.Open($filePath)

        # Select the appropriate worksheet (assuming it's the first one)
        $worksheet = $workbook.Sheets.Item(1)

        # Find the last used column in the first row
        $lastColumn = $worksheet.Cells.Item(1, $worksheet.Columns.Count).End(-4159).Column

        # Exclude the first column if specified
        if ($omitFirstColumn) {
            $lastColumn--
        }

        # Close Excel without saving changes
        $workbook.Close()
        $excel.Quit()
    } catch {
        Write-Host "An error occurred: $_"
        return -1
    } finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }

    return $lastColumn
}
