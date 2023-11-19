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

<#
.SYNOPSIS
Gets the value of a specified cell in an Excel file.

.DESCRIPTION
This function retrieves the value from a specific cell in an Excel worksheet, 
identified by row and column. The column can be specified using either its 
alphabetical letter or numerical index.

.PARAMETER filePath
The path of the Excel file.

.PARAMETER rowIndex
The index of the row of the cell.

.PARAMETER columnIndex
The index or letter of the column of the cell.

.EXAMPLE
# Get the value from cell at row 2, column B
$value = Get-ExcelCellValue -filePath "C:\Path\To\Your\Excel\File.xlsx" -rowIndex 2 -columnIndex 'B'
Write-Host "Cell value: $value"
#>

function Get-ExcelCellValue {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [int]$rowIndex,

        [Parameter(Mandatory=$true)]
        [object]$columnIndex  # Can be either an int or a string
    )

    # Convert column letter to number if necessary
    if ($columnIndex -is [string]) {
        $columnNumber = 0
        $columnIndex.ToCharArray() | ForEach-Object {
            $columnNumber = $columnNumber * 26 + ([int][char]$_ - [int][char]'A' + 1)
        }
        $columnIndex = $columnNumber
    }

    try {
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $workbook = $excel.Workbooks.Open($filePath)
        $worksheet = $workbook.Sheets.Item(1)

        # Retrieve the value
        $value = $worksheet.Cells.Item($rowIndex, $columnIndex).Value2

        # Close Excel without saving changes
        $workbook.Close()
        $excel.Quit()
    } catch {
        Write-Host "An error occurred: $_"
        return $null
    } finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }

    return $value
}

<#
.SYNOPSIS
Sets the value of a specified cell in an Excel file.

.DESCRIPTION
This function sets a value in a specific cell in an Excel worksheet, 
identified by row and column. The column can be specified using either its 
alphabetical letter or numerical index.

.PARAMETER filePath
The path of the Excel file.

.PARAMETER rowIndex
The index of the row of the cell.

.PARAMETER columnIndex
The index or letter of the column of the cell.

.PARAMETER value
The value to set in the specified cell.

.EXAMPLE
# Set the value in cell at row 2, column B
Set-ExcelCellValue -filePath "C:\Path\To\Your\Excel\File.xlsx" -rowIndex 2 -columnIndex 'B' -value "New Value"
#>

function Set-ExcelCellValue {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [int]$rowIndex,

        [Parameter(Mandatory=$true)]
        [object]$columnIndex,  # Can be either an int or a string

        [Parameter(Mandatory=$true)]
        [object]$value
    )

    # Convert column letter to number if necessary
    if ($columnIndex -is [string]) {
        $columnNumber = 0
        $columnIndex.ToCharArray() | ForEach-Object {
            $columnNumber = $columnNumber * 26 + ([int][char]$_ - [int][char]'A' + 1)
        }
        $columnIndex = $columnNumber
    }

    try {
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $workbook = $excel.Workbooks.Open($filePath)
        $worksheet = $workbook.Sheets.Item(1)

        # Set the value in the specified cell
        $worksheet.Cells.Item($rowIndex, $columnIndex).Value2 = $value

        # Save changes and close Excel
        $workbook.Save()
        $workbook.Close()
        $excel.Quit()
    } catch {
        Write-Host "An error occurred: $_"
        return $false
    } finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }
}

<#
.SYNOPSIS
Gets the data of a specified row in an Excel file as a hashtable.

.DESCRIPTION
This function retrieves the data from a specified row in an Excel file, 
matching the data with headers in the first row.

.PARAMETER filePath
The path of the Excel file.

.PARAMETER rowIndex
The index of the row for which data is to be retrieved.

.PARAMETER matchHeader
If specified, matches the data with headers in the first row.

.EXAMPLE
$excelFilePath = "C:\Path\To\Your\Excel\File.xlsx"
$rowIndex = 3
$rowData = Get-ExcelRowData -filePath $excelFilePath -rowIndex $rowIndex -matchHeader

foreach ($key in $rowData.Keys) {
    Write-Host "$key: $($rowData[$key])"
}

This example retrieves the data from row 3 of the Excel file and prints each cell's header and value.
#>

function Get-ExcelRowData {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [int]$rowIndex,

        [Parameter(Mandatory=$false)]
        [switch]$matchHeader
    )

    # Create a new Excel application
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false

    # Open the Excel file
    $workbook = $excel.Workbooks.Open($filePath)
    
    # Select the appropriate worksheet (assuming it's the first one)
    $worksheet = $workbook.Sheets.Item(1)

    # Determine headers if matchHeader is specified
    $headers = @()
    if ($matchHeader) {
        $headerRow = 1
        $headerCount = $worksheet.UsedRange.Columns.Count
        for ($i = 1; $i -le $headerCount; $i++) {
            $headers += $worksheet.Cells.Item($headerRow, $i).Text
        }
    }

    # Initialize a hashtable to store row data
    $rowData = @{}

    # Iterate through each column in the specified row
    $columnCount = $worksheet.UsedRange.Columns.Count
    for ($col = 1; $col -le $columnCount; $col++) {
        $cellValue = $worksheet.Cells.Item($rowIndex, $col).Text
        $key = if ($headers.Count -ge $col) { $headers[$col - 1] } else { $col - 1 }
        $rowData[$key] = $cellValue
    }

    # Close Excel without saving changes
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

    # Return the hashtable of data for the specified row
    return $rowData
}

<#
.SYNOPSIS
Gets the data of a specified column in an Excel file as a hashtable.

.DESCRIPTION
This function retrieves the data from a specified column in an Excel file, 
matching the data with headers in the first column.

.PARAMETER filePath
The path of the Excel file.

.PARAMETER columnIndex
The index of the column for which data is to be retrieved.

.PARAMETER matchFirstColumn
If specified, matches the data with headers in the first column.

.EXAMPLE
$excelFilePath = "C:\Path\To\Your\Excel\File.xlsx"
$columnIndex = 2
$columnData = Get-ExcelColumnData -filePath $excelFilePath -columnIndex $columnIndex -matchFirstColumn

foreach ($key in $columnData.Keys) {
    Write-Host "$key: $($columnData[$key])"
}

This example retrieves the data from column 2 of the Excel file and prints each cell's header and value.
#>

function Get-ExcelColumnData {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [int]$columnIndex,

        [Parameter(Mandatory=$false)]
        [switch]$matchFirstColumn
    )

    # Create a new Excel application
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false

    # Open the Excel file
    $workbook = $excel.Workbooks.Open($filePath)
    
    # Select the appropriate worksheet (assuming it's the first one)
    $worksheet = $workbook.Sheets.Item(1)

    # Determine headers if matchFirstColumn is specified
    $headers = @()
    if ($matchFirstColumn) {
        $headerColumn = 1
        $headerCount = $worksheet.UsedRange.Rows.Count
        for ($i = 1; $i -le $headerCount; $i++) {
            $headers += $worksheet.Cells.Item($i, $headerColumn).Text
        }
    }

    # Initialize a hashtable to store column data
    $columnData = @{}

    # Iterate through each row in the specified column
    $rowCount = $worksheet.UsedRange.Rows.Count
    for ($row = 1; $row -le $rowCount; $row++) {
        $cellValue = $worksheet.Cells.Item($row, $columnIndex).Text
        $key = if ($headers.Count -ge $row) { $headers[$row - 1] } else { $row - 1 }
        $columnData[$key] = $cellValue
    }

    # Close Excel without saving changes
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

    # Return the hashtable of data for the specified column
    return $columnData
}

<#
.SYNOPSIS
Sets data in a specified row of an Excel file.

.DESCRIPTION
This function sets values in a specified row of an Excel worksheet, starting from a given column (specified either as a number or a letter) or the first empty column if not specified.

.PARAMETER filePath
The path of the Excel file.

.PARAMETER rowIndex
The index of the row where data will be set.

.PARAMETER values
An array of values to be set in the row.

.PARAMETER startColumnIndex
The index (number or letter) of the column from which to start setting the values. If not specified, starts from the first empty column.

.EXAMPLE
$filePath = "C:\Path\To\Your\Excel\File.xlsx"
$rowIndex = 3
$values = @("Data1", "Data2", "Data3")
Set-ExcelRowData -filePath $filePath -rowIndex $rowIndex -values $values -startColumnIndex 'B'
#>

function Set-ExcelRowData {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath,

        [Parameter(Mandatory=$true)]
        [int]$rowIndex,

        [Parameter(Mandatory=$true)]
        [object[]]$values,

        [Parameter(Mandatory=$false)]
        [object]$startColumnIndex
    )

    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $workbook = $excel.Workbooks.Open($filePath)
    $worksheet = $workbook.Sheets.Item(1)

    # Convert column letter to number if necessary
    if ($startColumnIndex -is [string]) {
        $colNumber = 0
        $startColumnIndex.ToCharArray() | ForEach-Object {
            $colNumber = $colNumber * 26 + ([int][char]$_ - [int][char]'A' + 1)
        }
        $startColumnIndex = $colNumber
    }

    # Find the first empty column if startColumnIndex is not specified
    if (-not $startColumnIndex) {
        $startColumnIndex = 1
        while ($worksheet.Cells.Item($rowIndex, $startColumnIndex).Value2 -ne $null) {
            $startColumnIndex++
        }
    }

    # Set the values in the row
    for ($i = 0; $i -lt $values.Length; $i++) {
        $worksheet.Cells.Item($rowIndex, $startColumnIndex + $i).Value2 = $values[$i]
    }

    # Save and close the workbook
    $workbook.Save()
    $workbook.Close()
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
}
