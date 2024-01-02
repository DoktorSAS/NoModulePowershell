<#
.SYNOPSIS
Creates a new hashtable.

.DESCRIPTION
This function initializes a new hashtable for storing key-value pairs.

.EXAMPLE
$hashMap = Create-HashMap
#>
function Create-HashMap {
    return @{}
}

<#
.SYNOPSIS
Adds a key-value pair to a hashtable.

.DESCRIPTION
This function adds a specified key-value pair to a hashtable.

.PARAMETER HashMap
The hashtable to add the pair to.

.PARAMETER Key
The key for the pair.

.PARAMETER Value
The value for the pair.

.EXAMPLE
$hashMap = Create-HashMap
Set-HashMap -HashMap $hashMap -Key "key1" -Value "value1"
#>
function Set-HashMap {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$HashMap,

        [Parameter(Mandatory=$true)]
        $Key,

        [Parameter(Mandatory=$true)]
        $Value
    )

    $HashMap[$Key] = $Value
}

<#
.SYNOPSIS
Removes a key-value pair from a hashtable.

.DESCRIPTION
This function removes a specified key-value pair from a hashtable.

.PARAMETER HashMap
The hashtable to remove the pair from.

.PARAMETER Key
The key of the pair to remove.

.EXAMPLE
$hashMap = Create-HashMap
$hashMap["key1"] = "value1"
Remove-FromHashMap -HashMap $hashMap -Key "key1"
#>
function Remove-FromHashMap {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$HashMap,

        [Parameter(Mandatory=$true)]
        $Key
    )

    $HashMap.Remove($Key)
}

<#
.SYNOPSIS
Retrieves a value from a hashtable based on the key.

.DESCRIPTION
This function retrieves the value associated with a specified key from a hashtable.

.PARAMETER HashMap
The hashtable to retrieve the value from.

.PARAMETER Key
The key of the value to retrieve.

.EXAMPLE
$hashMap = Create-HashMap
$hashMap["key1"] = "value1"
$value = Get-FromHashMap -HashMap $hashMap -Key "key1"
Write-Host "Retrieved value: $value"
#>
function Get-FromHashMap {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$HashMap,

        [Parameter(Mandatory=$true)]
        $Key
    )

    return $HashMap[$Key]
}

<#
.SYNOPSIS
Updates the value of a specific key in a hashtable.

.DESCRIPTION
This function updates the value associated with a specified key in a hashtable.

.PARAMETER HashMap
The hashtable to update the value in.

.PARAMETER Key
The key of the value to update.

.PARAMETER NewValue
The new value for the key.

.EXAMPLE
$hashMap = Create-HashMap
$hashMap["key1"] = "oldValue"
Update-HashMapValue -HashMap $hashMap -Key "key1" -NewValue "newValue"
#>
function Update-HashMapValue {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$HashMap,

        [Parameter(Mandatory=$true)]
        $Key,

        [Parameter(Mandatory=$true)]
        $NewValue
    )

    if ($HashMap.ContainsKey($Key)) {
        $HashMap[$Key] = $NewValue
    }
    else {
        Write-Error "Key not found: $Key"
    }
}
