<#
.SYNOPSIS
Creates a new hashtable.

.DESCRIPTION
This function initializes a new hashtable for storing key-Value pairs.

.EXAMPLE
$hashMap = Create-HashMap
#>
function Create-HashMap {
    return @{}
}

<#
.SYNOPSIS
Adds a key-Value pair to a hashtable.

.DESCRIPTION
This function adds a specified key-Value pair to a hashtable.

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
Removes a key-Value pair from a hashtable.

.DESCRIPTION
This function removes a specified key-Value pair from a hashtable.

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
$Value = Get-FromHashMap -HashMap $hashMap -Key "key1"
Write-Host "Retrieved value: $Value"
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
Set-HashMapValue -HashMap $hashMap -Key "key1" -NewValue "newValue"
#>
function Set-HashMapValue {
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
