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
        [Parameter(Mandatory=$true)]
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
Checks if a specified property exists in a JSON object.

.DESCRIPTION
This function takes a JSON object and a property name as input and checks if the specified property exists in the JSON object.

.PARAMETER jsonObject
The JSON object in which to check for the property.

.PARAMETER propertyName
The name of the property to check for in the JSON object.

.EXAMPLE
$jsonObject = ConvertFrom-Json '{"name": "John", "age": 30}'
$propertyName = "age"
$exists = Test-JsonPropertyExists -jsonObject $jsonObject -propertyName $propertyName
Write-Host "Property Exists: $exists"
#>

function Test-JsonPropertyExists {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $jsonObject,

        [Parameter(Mandatory=$true)]
        [string]
        $propertyName
    )

    return $jsonObject.PSObject.Properties.Name -contains $propertyName
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
        [Parameter(Mandatory=$true)]
        [object]$jsonObject,

        [Parameter(Mandatory=$true)]
        [string]$propertyName,

        [Parameter(Mandatory=$true)]
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
Retrieves the value of a specified property from a JSON object.

.DESCRIPTION
This function searches for a specified property in a JSON object and returns its value.
If the property is not found directly in the object, it returns a specified default value or $null if no default value is provided.

.PARAMETER jsonObject
The JSON object from which the property value will be retrieved.

.PARAMETER propertyName
The name of the property to search for in the JSON object.

.PARAMETER defaultValue
The default value to return if the property is not found. This parameter is optional.

.EXAMPLE
$jsonObject = ConvertFrom-Json '{ "1": {"name": "John", "age": 30} }'
$propertyValue = Get-JsonProperty -jsonObject $jsonObject -propertyName "age" -defaultValue "Not Found"
Write-Host $propertyValue
#>

function Get-JsonProperty {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $jsonObject,

        [Parameter(Mandatory=$true)]
        [string]
        $propertyName,

        [Parameter(Mandatory=$false)]
        $defaultValue = $null
    )

    if ($jsonObject.PSObject.Properties[$propertyName]) {
        return $jsonObject.PSObject.Properties[$propertyName].Value
    } else {
        Write-Error "Property '$propertyName' not found. Please check if the property name is correct."
        return $defaultValue
    }
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
        [Parameter(Mandatory=$true)]
        [object]$jsonObject,

        [Parameter(Mandatory=$true)]
        [string]$propertyName,

        [Parameter(Mandatory=$true)]
        $propertyValue
    )

    # Check if the property already exists
    if ($jsonObject.$propertyName) {
        Write-Host "Property '$propertyName' already exists."
        return $null
    }

    # Add the new property
    $jsonObject | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
}

<#
.SYNOPSIS
Appends a new property to a JSON object.

.DESCRIPTION
This function takes a JSON object and appends a new property to it. The new property is added after the last existing property, maintaining the order of the properties.

.PARAMETER jsonObject
The JSON object to which the new property will be appended.

.PARAMETER propertyName
The name of the new property to be appended.

.PARAMETER propertyValue
The value of the new property to be appended.

.EXAMPLE
# Append a new property to a JSON object
$jsonObject = @{ "B" = "ValueB"; "C" = "ValueC"; "D" = "ValueD" }
Append-JsonProperty -jsonObject $jsonObject -propertyName "A" -propertyValue "ValueA"
Write-Host "Updated JSON Object: $($jsonObject | ConvertTo-Json -Depth 100)"
#>

function Append-JsonProperty {
    param (
        [Parameter(Mandatory=$true)]
        [object]$jsonObject,

        [Parameter(Mandatory=$true)]
        [string]$propertyName,

        [Parameter(Mandatory=$true)]
        $propertyValue
    )

    # Check if the property already exists
    if ($jsonObject.$propertyName) {
        Write-Host "Property '$propertyName' already exists."
        return $null
    }

    # Append the new property
    $jsonObject | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
}

<#
.SYNOPSIS
Selects specific tokens (properties) from a JSON object and creates a new JSON object containing only those tokens.

.DESCRIPTION
This function takes a JSON object and an array of token names (property names). It creates a new JSON object that includes only the specified tokens from the original JSON object. If a specified token does not exist in the original object, it will not be included in the new object.

.PARAMETER jsonObject
The JSON object from which tokens will be selected. This parameter is mandatory.

.PARAMETER tokens
An array of string token names to be selected from the JSON object. This parameter is mandatory.

.EXAMPLE
$jsonObject = ConvertFrom-Json '{ "name": "John", "age": 30, "city": "New York"}'
$tokens = @("name", "city")
$selectedObject = Select-JsonTokens -jsonObject $jsonObject -tokens $tokens
Write-Host "Selected JSON Object: $($selectedObject | ConvertTo-Json -Depth 100)"
#>
function Select-JsonTokens {
    param (
        [Parameter(Mandatory=$true)]
        [object]$jsonObject,

        [Parameter(Mandatory=$true)]
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

<#
.SYNOPSIS
Finds all instances of a specified property within a JSON object.

.DESCRIPTION
This function searches through a JSON object and returns all instances (parents) where the specified property is found, including in nested objects.

.PARAMETER jsonObject
The JSON object in which to search for the property.

.PARAMETER propertyName
The name of the property to search for in the JSON object.

.EXAMPLE
$jsonObject = ConvertFrom-Json '{
    "000001": { "name": "Luke", "age": "16", "contacts": {"email": "luke@email.com", "phone": "+39 1234567"} },  
    "000002": { "name": "Tom", "age": "16", "contacts": {"email": "tom@email.com", "phone": "+39 1234568" } }
}'
$propertyName = "email"
$instances = Find-JsonPropertyInstances -jsonObject $jsonObject -propertyName $propertyName
Write-Host "Instances Found: $($instances | ConvertTo-Json -Depth 100)"
#>

function Find-JsonPropertyInstances {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $jsonObject,

        [Parameter(Mandatory=$true)]
        [string]
        $propertyName
    )

    $foundInstances = @()

    function Search-Object {
        param(
            [PSCustomObject]
            $obj,
            [ref]
            $found
        )

        foreach ($property in $obj.PSObject.Properties) {
            if ($property.Name -eq $propertyName) {
                $found.Value += $obj
                break
            } elseif ($property.Value -is [PSCustomObject]) {
                Search-Object -obj $property.Value -found $found
            }
        }
    }

    foreach ($key in $jsonObject.PSObject.Properties.Name) {
        $item = $jsonObject.$key
        Search-Object -obj $item -found ([ref]$foundInstances)
    }

    return $foundInstances
}