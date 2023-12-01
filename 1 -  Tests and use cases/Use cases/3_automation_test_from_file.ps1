<#
.SYNOPSIS
This script performs a scenario where data is read from an Excel file, and HTTP POST requests are made to a specific API endpoint (in this case, "https://jsonplaceholder.typicode.com/posts"). The script then processes the POST response, extracts the 'postId', and uses it to perform HTTP GET requests to another API endpoint ("https://jsonplaceholder.typicode.com/posts/{postId}/comments"). The GET responses are processed, and the relevant data is updated in the Excel file.

.DESCRIPTION
The script follows these steps:
1. Create a unique copy of the Excel file, assuming the source file is named "file.xlsx."
2. Perform HTTP POST requests for each row in the Excel file, creating new posts.
3. Extract and process the POST response, updating the Excel file with the 'postId.'
4. Perform HTTP GET requests for each row, retrieving comments for each post.
5. Process the GET response, updating the Excel file with comment data.

Note:
- The Excel file should have columns with headers "userId," "title," and possibly additional columns for storing 'postId' and comment-related data.
- Ensure that the Excel module (Excel.ps1) and the HTTP module (HTTP.ps1) are available in the script directory.
#>

. '.\Excel\Excel.ps1'
. '.\Json\Json.ps1'
. '.\HTTP\HTTP.ps1'

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
$relativeSourceFilePath = ".\3_automation_test_from_file.xlsx"
$sourceFilePath = Join-Path -Path $scriptDirectory -ChildPath $relativeSourceFilePath
$destinationDirectory = $scriptDirectory

Write-HostWithTimestamp "Creating a unique copy of the Excel file from $sourceFilePath..."
$copyFilePath = Copy-ExcelFile -SourceFilePath $sourceFilePath -DestinationDirectory $destinationDirectory -Unique

$rowCount = Get-ExcelRowCount -filePath $copyFilePath

# Step 1: HTTP POST Requests
Write-HostWithTimestamp "Performing HTTP POST requests..."
for ($i = 2; $i -le $rowCount; $i++) {
    # Read data from the Excel file
    $rowData = Get-ExcelRowData -filePath $copyFilePath -rowIndex $i -matchHeader

    # Convert the row data to JSON
    $jsonObject = [PSCustomObject]@{
        userId = $rowData["userId"]
        title  = $rowData["title"]
        body   = "This is a body text"
    }
    $jsonBody = $jsonObject | ConvertTo-Json

    # Send the HTTP POST request
    $postResponse = Invoke-HttpPostRequest -Url "https://jsonplaceholder.typicode.com/posts" -Body $jsonBody

    $isValidJsonString = Test-JsonString -jsonString $postResponse
    if ($isValidJsonString) {
        $postResponse = ConvertFrom-Json $postResponse
    }

    # Process the POST response
    $postId = Get-JsonProperty -jsonObject $postResponse -propertyName "id" -defaultValue ""
    # Save or process the response data as needed

    # Update the Excel file with the POST response data
    $postUpdatedValues = @($postId)  # Assuming a column for 'postId'
    Set-ExcelRowData -filePath $copyFilePath -rowIndex $i -startColumnIndex 3 -values $postUpdatedValues
}

# Step 2: HTTP GET Requests
Write-HostWithTimestamp "Performing HTTP GET requests..."
for ($i = 2; $i -le $rowCount; $i++) {
    # Read data from the Excel file
    $rowData = Get-ExcelRowData -filePath $copyFilePath -rowIndex $i -matchHeader

    # Assume each element has a postId obtained from the previous POST response
    $postId = $rowData["userId"]

    # Construct the URL for the GET request based on postId
    $getUrl = "https://jsonplaceholder.typicode.com/posts/$postId/comments"

    # Send the HTTP GET request
    $getResponse = Invoke-HttpGetRequest -Url $getUrl

    $isValidJsonString = Test-JsonString -jsonString $getResponse
    if ($isValidJsonString) {
        $getResponse = ConvertFrom-Json $getResponse
    }

    # Process the GET response
    $commentNames = @()
    $commentEmails = @()
    $commentBodys = @()
    foreach ($comment in $getResponse) {
        # Save or process the comment data as needed
        $commentName = Get-JsonProperty -jsonObject $comment -propertyName "name" -defaultValue ""
        $commentEmail = Get-JsonProperty -jsonObject $comment -propertyName "email" -defaultValue ""
        $commentBody = Get-JsonProperty -jsonObject $comment -propertyName "body" -defaultValue ""
        Write-HostWithTimestamp "Comment Name: $commentName, Email: $commentEmail, Body: $commentBody"
        $commentNames += $commentName
        $commentEmails += $commentEmail
        $commentBodys += $commentBodys

    }

    # Update the Excel file with the GET response data
    $getUpdatedValues = @($commentNames, $commentEmails, $commentBodys)  
    Set-ExcelRowData -filePath $copyFilePath -rowIndex $i -startColumnIndex 4 -values $getUpdatedValues
}

Write-HostWithTimestamp "Alternative test completed successfully."
