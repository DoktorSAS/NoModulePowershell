# HashMap.ps1 Function Documentation

The `HashMap.ps1` file within the NoModulePowershell library provides a comprehensive suite of functions for managing hashmaps (hashtables) in PowerShell. It includes functionalities for creating hashmaps, adding key-Value pairs, removing pairs, updating values, and retrieving data based on keys. This script is a powerful tool for handling key-Value paired data, offering fast retrieval and efficient data organization. HashMap.ps1 is crucial for scripts that require quick access to data, easy data updates, and structured data storage in key-Value format

## List of Functions

1. [Create-HashMap](#Create-HashMap)
2. [Set-HashMap](#Set-HashMap)
3. [Remove-FromHashMap](#Remove-FromHashMap)
4. [Get-FromHashMap](#Get-FromHashMap)
5. [Set-HashMapValue](#Set-HashMapValue)

---

## Create-HashMap

Creates a new hashtable.

Usage:

```powershell
$hashMap = Create-HashMap
```

## Set-HashMap

Adds a key-Value pair to a hashtable.

| Argument | Type      | Mandatory | Description                         | Example Value |
|----------|-----------|-----------|-------------------------------------|---------------|
| HashMap  | hashtable | Yes       | The hashtable to add the pair to.   | `$hashMap`    |
| Key      | Object    | Yes       | The key for the pair.               | `"key1"`      |
| Value    | Object    | Yes       | The value for the pair.             | `"value1"`    |

Usage:

```powershell
$hashMap = Create-HashMap
Set-HashMap -HashMap $hashMap -Key "key1" -Value "value1"
```

## Remove-FromHashMap

Removes a key-Value pair from a hashtable.

| Argument | Type      | Mandatory | Description                           | Example Value |
|----------|-----------|-----------|---------------------------------------|---------------|
| HashMap  | hashtable | Yes       | The hashtable to remove the pair from.| `$hashMap`    |
| Key      | Object    | Yes       | The key of the pair to remove.        | `"key1"`      |

Usage:

```powershell
$hashMap = Create-HashMap
$hashMap["key1"] = "value1"
Remove-FromHashMap -HashMap $hashMap -Key "key1"
```

---

## Get-FromHashMap

Retrieves a value from a hashtable based on the key.

| Argument | Type      | Mandatory | Description                         | Example Value |
|----------|-----------|-----------|-------------------------------------|---------------|
| HashMap  | hashtable | Yes       | The hashtable to retrieve the value from.| `$hashMap`|
| Key      | Object    | Yes       | The key of the value to retrieve.   | `"key1"`      |

Usage:

```powershell
$hashMap = Create-HashMap
$hashMap["key1"] = "value1"
$Value = Get-FromHashMap -HashMap $hashMap -Key "key1"
Write-Host "Retrieved value: $Value"
```

---

## Set-HashMapValue

Updates the value of a specific key in a hashtable.

| Argument | Type      | Mandatory | Description                           | Example Value |
|----------|-----------|-----------|---------------------------------------|---------------|
| HashMap  | hashtable | Yes       | The hashtable to update the value in. | `$hashMap`    |
| Key      | Object    | Yes       | The key of the value to update.       | `"key1"`      |
| NewValue | Object    | Yes       | The new value for the key.            | `"newValue"`  |

Usage:

```powershell
$hashMap = Create-HashMap
$hashMap["key1"] = "oldValue"
Set-HashMapValue -HashMap $hashMap -Key "key1" -NewValue "newValue"
```

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>