<#
.SYNOPSIS
This script extends the functionality of sending data to JSONPlaceholder by also retrieving related data through a GET request.

.DESCRIPTION
The script follows these steps:
1. Creates a unique copy of an Excel file and reads data from each row.
2. Sends the data as a POST request to JSONPlaceholder, creating a new post.
3. After creating each post, it immediately makes a GET request to retrieve comments associated with that post.
4. The number of comments and other response data are then saved back into the Excel file.

This script demonstrates a more complex interaction with an API, where two different types of requests (POST and GET) are used in conjunction to simulate a real-world application of posting data and retrieving related information.
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

$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$relativeSourceFilePath = ".\file.xlsx"
$sourceFilePath = Join-Path -Path $scriptDirectory -ChildPath $relativeSourceFilePath
$destinationDirectory = $scriptDirectory

Write-HostWithTimestamp "Creating a unique copy of the Excel file from $sourceFilePath..."
$copyFilePath = Copy-ExcelFile -SourceFilePath $sourceFilePath -DestinationDirectory $destinationDirectory -Unique

$rowCount = Get-ExcelRowCount -FilePath $copyFilePath

Write-HostWithTimestamp "Reading data from the Excel file and creating JSON objects..."
for ($i = 2; $i -le $rowCount; $i++) {
    $rowData = Get-ExcelRowData -FilePath $copyFilePath -RowIndex $i -MatchHeader
    $JsonObject = [PSCustomObject]@{
        userId = $rowData["userId"]
        title  = $rowData["title"]
        body   = "This is a body text"
    }
    $jsonBody = $JsonObject | ConvertTo-Json

    $postUrl = "https://jsonplaceholder.typicode.com/posts"
    Write-HostWithTimestamp "Sending HTTP POST request with body: $jsonBody"
    
    $postResponse = Invoke-HttpPostRequest -Url $postUrl -Body $jsonBody

    $isValidJsonString = Test-JsonString -JsonString $postResponse
    if ($isValidJsonString) {
        $postResponse = ConvertFrom-Json $postResponse
    }

    # Seconda richiesta: GET per recuperare i commenti del post
    $commentsUrl = "https://jsonplaceholder.typicode.com/posts/$($postResponse.id)/comments"
    Write-HostWithTimestamp "Retrieving comments for the post with ID: $($postResponse.id)"
    $commentsResponse = Invoke-HttpGetRequest -Url $commentsUrl

    # Salvataggio dei risultati nel file Excel
    Write-HostWithTimestamp "Saving post and comments data to Excel file..."
    $idValue = Get-JsonProperty -JsonObject $postResponse -PropertyName "id" -DefaultValue ""
    $titleValue = Get-JsonProperty -JsonObject $postResponse -PropertyName "title" -DefaultValue ""
    $commentsCount = ($commentsResponse | ConvertFrom-Json).Count

    $updatedValues = @($idValue, $titleValue, $commentsCount) # Aggiungi una colonna per i commenti
    Set-ExcelRowData -FilePath $copyFilePath -RowIndex $i -StartColumnIndex 3 -Values $updatedValues
}

Write-HostWithTimestamp "Automation completed successfully."
