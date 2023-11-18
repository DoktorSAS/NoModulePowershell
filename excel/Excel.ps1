<#
.SYNOPSIS
Creates a new Excel file with optional specified headers.

.DESCRIPTION
This function creates a new Excel file with the provided file path and file name. 
If provided, it sets the header row in the Excel file and formats every cell as text. 
If headers are not provided, it creates an empty Excel file.

.PARAMETER filePath
The path where the Excel file will be saved. This parameter is mandatory.

.PARAMETER fileName
The name of the Excel file (without extension). This parameter is mandatory.

.PARAMETER headers
An array of header names. This parameter is optional.

.EXAMPLE
$filePath = "C:\Path\To\Your"
$fileName = "MyExcelFile"
$headers = @("Name", "Age", "City")
Create-ExcelFile -filePath $filePath -fileName $fileName -headers $headers

.EXAMPLE
$filePath = "C:\Path\To\Your"
$fileName = "MyEmptyExcelFile"
Create-ExcelFile -filePath $filePath -fileName $fileName
#>

function Create-ExcelFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [string]$fileName,

        [Parameter(Mandatory=$false)]
        [string[]]$headers
    )

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

    # Save the workbook with a unique timestamp in the filename
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $uniqueNumber = Get-Random -Minimum 10000 -Maximum 99999
    $outputFileName = "$fileName-$timestamp-$uniqueNumber.xlsx"
    $outputFilePath = Join-Path $filePath $outputFileName

    $workbook.SaveAs($outputFilePath)
    $excel.Quit()

    Write-Host "Excel file created: $outputFilePath"
    return $outputFilePath
}
