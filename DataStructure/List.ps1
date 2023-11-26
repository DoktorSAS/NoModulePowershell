<#
.SYNOPSIS
Creates a new ArrayList.

.DESCRIPTION
This function initializes a new ArrayList.

.EXAMPLE
$list = Create-List
#>
function Create-List {
    return New-Object System.Collections.ArrayList
}

<#
.SYNOPSIS
Adds an item to an ArrayList.

.DESCRIPTION
This function adds a specified item to an ArrayList.

.PARAMETER List
The list to which the item will be added.

.PARAMETER Item
The item to add to the list.

.EXAMPLE
$list = Create-List
Add-ToList -List $list -Item "New Item"
#>
function Add-ToList {
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$List,

        [Parameter(Mandatory=$true)]
        $Item
    )

    $List.Add($Item) | Out-Null
}

<#
.SYNOPSIS
Removes an item from an ArrayList.

.DESCRIPTION
This function removes a specified item from an ArrayList.

.PARAMETER List
The list to remove the item from.

.PARAMETER Item
The item to remove from the list.

.EXAMPLE
$list = Create-List
$list.Add("Item to Remove")
Remove-FromList -List $list -Item "Item to Remove"
#>
function Remove-FromList {
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$List,

        [Parameter(Mandatory=$true)]
        $Item
    )

    $List.Remove($Item) | Out-Null
}

<#
.SYNOPSIS
Retrieves an item from an ArrayList by index.

.DESCRIPTION
This function retrieves an item from an ArrayList based on its index.

.PARAMETER List
The list from which to retrieve the item.

.PARAMETER Index
The index of the item in the list.

.EXAMPLE
$list = Create-List
$list.Add("First Item")
$item = Get-FromList -List $list -Index 0
Write-Host "Retrieved item: $item"
#>
function Get-FromList {
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$List,

        [Parameter(Mandatory=$true)]
        [int]$Index
    )

    if ($Index -lt 0 -or $Index -ge $List.Count) {
        Write-Error "Index out of range"
        return $null
    }

    return $List[$Index]
}

<#
.SYNOPSIS
Updates an item in an ArrayList at a specified index.

.DESCRIPTION
This function updates an item at a specified index in an ArrayList.

.PARAMETER List
The list in which to update the item.

.PARAMETER Index
The index of the item to update.

.PARAMETER NewItem
The new item to replace the old item.

.EXAMPLE
$list = Create-List
$list.Add("Old Item")
Update-ListElement -List $list -Index 0 -NewItem "Updated Item"
#>
function Update-ListElement {
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$List,

        [Parameter(Mandatory=$true)]
        [int]$Index,

        [Parameter(Mandatory=$true)]
        $NewItem
    )

    if ($Index -lt 0 -or $Index -ge $List.Count) {
        Write-Error "Index out of range"
        return $null
    }

    $List[$Index] = $NewItem
}
