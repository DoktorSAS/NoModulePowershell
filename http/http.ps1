<#
.SYNOPSIS
Sends a HTTP GET request to a specified URL.

.DESCRIPTION
This function sends a HTTP GET request to the specified URL and returns the response.
It is useful for retrieving data from APIs or web services.

.PARAMETER Url
The URL to which the GET request will be sent.

.PARAMETER Headers
Optional headers for the GET request.

.EXAMPLE
$response = Invoke-HttpGetRequest -Url "http://example.com/api/data"

.EXAMPLE
$headers = @{ "Authorization" = "Bearer your_token" }
$response = Invoke-HttpGetRequest -Url "http://example.com/api/data" -Headers $headers
#>

function Invoke-HttpGetRequest {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$false)]
        [hashtable]$Headers
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -Method Get -Headers $Headers
        return $response
    } catch {
        Write-Error "An error occurred: $_"
        return $null
    }
}

<#
.SYNOPSIS
Sends a HTTP POST request to a specified URL.

.DESCRIPTION
This function sends a HTTP POST request to the specified URL with the provided data.
It is useful for submitting data to APIs or web services.

.PARAMETER Url
The URL to which the POST request will be sent.

.PARAMETER Body
The string data to be sent in the POST request.

.PARAMETER Headers
Optional headers for the POST request.

.EXAMPLE
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPostRequest -Url "http://example.com/api/users" -Body $data

.EXAMPLE
$headers = @{ "Content-Type" = "application/json" }
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPostRequest -Url "http://example.com/api/users" -Body $data -Headers $headers
#>

function Invoke-HttpPostRequest {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$Body,

        [Parameter(Mandatory=$false)]
        [hashtable]$Headers
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -Method Post -ContentType "application/json" -Body $Body -Headers $Headers
        return $response
    } catch {
        Write-Error "An error occurred: $_"
        return $null
    }
}

<#
.SYNOPSIS
Sends a HTTP PUT request to a specified URL.

.DESCRIPTION
This function sends a HTTP PUT request to the specified URL with the provided data.
It is useful for updating resources or data on APIs or web services.

.PARAMETER Url
The URL to which the PUT request will be sent.

.PARAMETER Body
The string data to be sent in the PUT request.

.PARAMETER Headers
Optional headers for the PUT request.

.EXAMPLE
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPutRequest -Url "http://example.com/api/users/1" -Body $data

.EXAMPLE
$headers = @{ "Content-Type" = "application/json" }
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPutRequest -Url "http://example.com/api/users/1" -Body $data -Headers $headers
#>

function Invoke-HttpPutRequest {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$Body,

        [Parameter(Mandatory=$false)]
        [hashtable]$Headers
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -Method Put -ContentType "application/json" -Body $Body -Headers $Headers
        return $response
    } catch {
        Write-Error "An error occurred: $_"
        return $null
    }
}
