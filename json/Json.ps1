<#
.SYNOPSIS
Validates if a string can be converted to a JSON object.

.DESCRIPTION
This function takes a string as input and checks if it can be successfully converted to a JSON object.

.PARAMETER jsonString
The string to be validated.

.EXAMPLE
# Validate if a string can be converted to a JSON object
$jsonString = '{"name": "John", "age": 30}'
$isValid = Test-JsonString -jsonString $jsonString
Write-Host "Is Valid JSON: $isValid"
#>

function Test-JsonString {
    param (
        [string]$jsonString
    )

    try {
        $null = $jsonString | ConvertFrom-Json
        return $true
    } catch {
        return $false
    }
}

<#
.SYNOPSIS
Sets the value of a property in a JSON object.

.DESCRIPTION
This function takes a JSON object, a property name, and a new value. It sets the specified property in the JSON object to the provided value.

.PARAMETER jsonObject
The JSON object to be modified.

.PARAMETER propertyName
The name of the property to be set.

.PARAMETER newValue
The new value to set for the specified property.

.EXAMPLE
$jsonObject = '{"name": "John", "age": 30, "city": "New York"}' | ConvertFrom-Json
$propertyName = "age"
$newValue = 31
Set-JsonProperty -jsonObject $jsonObject -propertyName $propertyName -newValue $newValue
Write-Host "Modified JSON Object: $($jsonObject | ConvertTo-Json -Depth 100)"
#>

function Set-JsonProperty {
    param (
        [object]$jsonObject,
        [string]$propertyName,
        [object]$newValue
    )

    # Check if the input is a JSON object
    if ($jsonObject -isnot [System.Management.Automation.PSCustomObject]) {
        Write-Host "Error: Input is not a valid JSON object."
        return $null
    }

    # Set the value of the specified property
    $jsonObject.$propertyName = $newValue
}

<#
.SYNOPSIS
Gets the value of a specific property in a JSON object.

.DESCRIPTION
This function takes a JSON object and a property name. It retrieves and returns the value of the specified property from the JSON object.

.PARAMETER jsonObject
The JSON object from which to get the property value.

.PARAMETER propertyName
The name of the property whose value is to be retrieved.

.EXAMPLE
$jsonObject = '{"name": "John", "age": 30, "city": "New York"}' | ConvertFrom-Json
$propertyName = "age"
$propertyValue = Get-JsonProperty -jsonObject $jsonObject -propertyName $propertyName
Write-Host "Value of Property '$propertyName': $propertyValue"
#>

function Get-JsonProperty {
    param (
        [object]$jsonObject,
        [string]$propertyName
    )

    # Check if the input is a JSON object
    if ($jsonObject -isnot [System.Management.Automation.PSCustomObject]) {
        Write-Host "Error: Input is not a valid JSON object."
        return $null
    }

    # Get the value of the specified property
    $propertyValue = $jsonObject.$propertyName

    # Return the property value
    return $propertyValue
}

<#
.SYNOPSIS
Adds a new property to a JSON object if the property does not exist.

.DESCRIPTION
This function takes a JSON object and a new property name and value. If the property
does not already exist in the JSON object, it is added.

.PARAMETER jsonObject
The JSON object to which the new property will be added.

.PARAMETER propertyName
The name of the new property to be added.

.PARAMETER propertyValue
The value of the new property to be added.

.EXAMPLE
# Add a new property to a JSON object
$jsonObject = @{ "key1" = "value1" }
Add-JsonProperty -jsonObject $jsonObject -propertyName "key2" -propertyValue "value2"
Write-Host "Updated JSON Object: $($jsonObject | ConvertTo-Json -Depth 100)"
#>

function Add-JsonProperty {
    param (
        [object]$jsonObject,
        [string]$propertyName,
        $propertyValue
    )

    # Check if the property already exists
    if (-not $jsonObject.$propertyName) {
        # Add the new property
        $jsonObject | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
    }
}

function Select-JsonTokens {
    param (
        [object]$jsonObject,
        [string[]]$tokens
    )

    # Check if the input is a JSON object
    if ($jsonObject -isnot [System.Management.Automation.PSCustomObject]) {
        Write-Host "Error: Input is not a valid JSON object."
        return $null
    }

    # Initialize a new JSON object
    $selectedJson = [PSCustomObject]@{}

    # Iterate through each token and add corresponding elements to the new JSON object
    foreach ($token in $tokens) {
        if ($jsonObject.PSObject.Properties.Name -contains $token) {
            $selectedJson | Add-Member -MemberType NoteProperty -Name $token -Value $jsonObject.$token
        }
    }

    # Return the new JSON object
    return $selectedJson
}