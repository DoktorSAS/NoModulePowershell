# List.ps1 Function Documentation

The `List.ps1` script is designed to handle dynamic list (ArrayList) operations in PowerShell, providing a versatile set of functions for managing lists. This script simplifies tasks like adding, removing, and updating items within a list, along with retrieval of specific elements. List.ps1 is particularly useful for scenarios where the size of the collection can change dynamically, offering more flexibility than standard arrays. It serves as an essential tool for scripting in PowerShell where dynamic data manipulation and list management are required.


## List of Functions

1. [Create-List](#Create-List) - Crea una nuova lista (ArrayList).
2. [Add-ToList](#Add-ToList) - Aggiunge un elemento a una lista.
3. [Remove-FromList](#Remove-FromList) - Rimuove un elemento da una lista.
4. [Get-FromList](#Get-FromList) - Ottiene un elemento da una lista.
5. [Update-ListElement](#Update-ListElement) - Aggiorna un elemento in una lista.

---

## Create-List

Creates a new ArrayList.

Usage:

```powershell
$list = Create-List
```

## Add-ToList

Adds an item to an ArrayList.

| Argument | Type              | Mandatory | Description                            | Example Value    |
|----------|-------------------|-----------|----------------------------------------|------------------|
| List     | ArrayList         | Yes       | The list to which the item will be added. | `$list`         |
| Item     | Object            | Yes       | The item to add to the list.              | `"New Item"`    |

Usage:

```powershell
$list = Create-List
Add-ToList -List $list -Item "New Item"
```

## Remove-FromList

Removes an item from an ArrayList.

| Argument | Type              | Mandatory | Description                            | Example Value    |
|----------|-------------------|-----------|----------------------------------------|------------------|
| List     | ArrayList         | Yes       | The list to remove the item from.          | `$list`         |
| Item     | Object            | Yes       | The item to remove from the list.         | `"Item to Remove"`|

Usage:

```powershell
$list = Create-List
$list.Add("Item to Remove")
Remove-FromList -List $list -Item "Item to Remove"
```

## Get-FromList

Retrieves an item from an ArrayList by index.

| Argument | Type              | Mandatory | Description                            | Example Value    |
|----------|-------------------|-----------|----------------------------------------|------------------|
| List     | ArrayList         | Yes       | The list from which to retrieve the item. | `$list`         |
| Index    | Int               | Yes       | The index of the item in the list.         | `0`             |

Usage:

```powershell
$list = Create-List
$list.Add("First Item")
$item = Get-FromList -List $list -Index 0
Write-Host "Retrieved item: $item"
```

## Update-ListElement

Updates an item in an ArrayList at a specified index.

| Argument | Type              | Mandatory | Description                            | Example Value    |
|----------|-------------------|-----------|----------------------------------------|------------------|
| List     | ArrayList         | Yes       | The list in which to update the item.  | `$list`         |
| Index    | Int               | Yes       | The index of the item to update.       | `0`             |
| NewItem  | Object            | Yes       | The new item to replace the old item.  | `"Updated Item"`|

Usage:

```powershell
$list = Create-List
$list.Add("Old Item")
Update-ListElement -List $list -Index 0 -NewItem "Updated Item"
```

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>