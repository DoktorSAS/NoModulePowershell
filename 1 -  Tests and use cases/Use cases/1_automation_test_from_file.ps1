<#
.SYNOPSIS
This script demonstrates an automated process of reading data from an Excel file, 
sending it as a POST request to JSONPlaceholder, and saving the response back into the Excel file.

.DESCRIPTION
The script performs the following steps:
1. Creates a unique copy of a specified Excel file to avoid modifying the original file.
2. Reads data from each row of the Excel file, starting from the second row (assuming the first row as headers).
3. For each row, it constructs a JSON object and sends it as a POST request to the JSONPlaceholder API.
4. The response from the API, which includes a generated post ID, is then saved back into the corresponding row in the Excel file.

This script is useful for simulating the process of sending data from an Excel file to a web API and handling the responses.
#>

. '.\Excel\Excel.ps1'
. '.\Json\Json.ps1'
. '.\HTTP\HTTP.ps1'

# Funzione helper per aggiungere timestamp ai messaggi
function Write-HostWithTimestamp {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

# Determine the current script directory
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Step 1: Create a unique copy of the Excel file
$relativeSourceFilePath = ".\file.xlsx" # Relative path of your source file
$sourceFilePath = Join-Path -Path $scriptDirectory -ChildPath $relativeSourceFilePath
$destinationDirectory = $scriptDirectory # Use script directory as destination

Write-HostWithTimestamp "Creating a unique copy of the Excel file from $sourceFilePath..."
$copyFilePath = Copy-ExcelFile -SourceFilePath $sourceFilePath -DestinationDirectory $destinationDirectory -Unique

# Get the number of rows in the Excel file
$rowCount = Get-ExcelRowCount -filePath $copyFilePath

# Step 2: Read each row and create JSON objects
Write-HostWithTimestamp "Reading data from the Excel file and creating JSON objects..."
for ($i = 2; $i -le $rowCount; $i++) {
    $rowData = Get-ExcelRowData -filePath $copyFilePath -rowIndex $i -matchHeader
    $jsonObject = [PSCustomObject]@{
        userId = $rowData["userId"]
        title  = $rowData["title"]
        body   = "This is a body text"  # Static body text or can be modified as needed
    }
    $jsonBody = $jsonObject | ConvertTo-Json

    # Step 3 & 4: Build the HTTP request body and send the request
    $url = "https://jsonplaceholder.typicode.com/posts" # Posts endpoint
    Write-HostWithTimestamp "Sending HTTP POST request with body: $jsonBody"
    
    # Send the HTTP POST request
    $response = Invoke-HttpPostRequest -Url $url -Body $jsonBody

    # Check if the response is a valid JSON
    $isValidJsonString = Test-JsonString -jsonString $response
    if ($isValidJsonString) {
        $response = ConvertFrom-Json $response
        Write-HostWithTimestamp $response
    }

    # Step 5: Save the results back into the copied Excel file
    Write-HostWithTimestamp "Saving response data to Excel file..."
    $idValue = Get-JsonProperty -jsonObject $response -propertyName "id" -defaultValue ""
    $titleValue = Get-JsonProperty -jsonObject $response -propertyName "title" -defaultValue ""
    
    $updatedValues = @($idValue, $titleValue) # Assuming columns for 'id' and 'title'
    Set-ExcelRowData -filePath $copyFilePath -rowIndex $i -startColumnIndex 3 -values $updatedValues
}

Write-HostWithTimestamp "Automation completed successfully."
