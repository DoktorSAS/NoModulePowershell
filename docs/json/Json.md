# Json.ps1 Function Documentation

The `Json.ps1` file in the NoModulePowershell library provides a suite of functions designed to enhance and simplify the handling of JSON data in PowerShell scripts. These functions offer a more intuitive and error-resistant approach to JSON manipulation, ensuring clear and predictable behaviors. The file is tailored to support a wide range of common JSON operations, from basic parsing and property manipulation to more advanced data selection and validation techniques.

## List of Functions

1. [Test-JsonString](#test-jsonstring)
2. [Test-JsonPropertyExists](#test-jsonpropertyexists)
3. [Set-JsonProperty](#set-jsonproperty)
4. [Get-JsonProperty](#get-jsonproperty)
5. [Add-JsonProperty](#add-jsonproperty)
6. [Append-JsonProperty](#append-jsonproperty)
7. [Select-JsonTokens](#select-jsontokens)
8. [Find-JsonPropertyInstances](#find-jsonpropertyinstances)

---

## Test-JsonString

This function checks if a provided string is a valid JSON object. It's useful for validating JSON data before attempting to parse or manipulate it, thereby preventing errors due to invalid JSON formats.

| Argument    | Type   | Mandatory | Example Value             |
|-------------|--------|-----------|---------------------------|
| jsonString  | string | Yes       | '{"name": "John", "age": 30}' |

```powershell
$isValid = Test-JsonString -jsonString $jsonString
```

If `$isValid` is `true`, the string is a valid JSON object; if `false`, it is not.

---

## Test-JsonPropertyExists

Checks if a specified property exists in a JSON object. This function is useful for validating the presence of a property before attempting operations that depend on its existence.

| Argument     | Type   | Mandatory | Description                                      | Example Value                                    |
|--------------|--------|-----------|--------------------------------------------------|--------------------------------------------------|
| jsonObject   | object | Yes       | The JSON object in which to check for the property | `ConvertFrom-Json '{"name": "John", "age": 30}'` |
| propertyName | string | Yes       | The name of the property to check for in the JSON object | 'age'                                          |

Usage:

```powershell
$jsonObject = ConvertFrom-Json '{"name": "John", "age": 30}'
$propertyName = "age"
$exists = Test-JsonPropertyExists -jsonObject $jsonObject -propertyName $propertyName
Write-Host "Property Exists: $exists"
```

---

## Set-JsonProperty

Sets the value of a specified property in a JSON object. This function is useful for modifying JSON objects dynamically.

| Argument    | Type   | Mandatory | Example Value             |
|-------------|--------|-----------|---------------------------|
| jsonObject  | object | Yes       | `ConvertFrom-Json '{"name": "John", "age": 30}'` |
| propertyName| string | Yes       | 'age'                     |
| newValue    | object | Yes       | 31                        |

```powershell
Set-JsonProperty -jsonObject $jsonObject -propertyName "age" -newValue 31
```

---

## Get-JsonProperty

Retrieves the value of a specified property from a JSON object. This function is handy for extracting specific data from JSON structures.

| Argument    | Type   | Mandatory | Example Value             |
|-------------|--------|-----------|---------------------------|
| jsonObject  | object | Yes       | `ConvertFrom-Json '{"name": "John", "age": 30}'` |
| propertyName| string | Yes       | 'age'                     |
| defaultValue| *      | No        | 'undefined'               |

```powershell
$propertyValue = Get-JsonProperty -jsonObject $jsonObject -propertyName "age"
```

---

## Add-JsonProperty

Adds a new property to a JSON object if it does not already exist. This function enables dynamic expansion of JSON objects.

| Argument     | Type   | Mandatory | Example Value             |
|--------------|--------|-----------|---------------------------|
| jsonObject   | object | Yes       | `ConvertFrom-Json '{"name": "John"}'` |
| propertyName | string | Yes       | 'age'                     |
| propertyValue| object | Yes       | 30                        |

```powershell
Add-JsonProperty -jsonObject $jsonObject -propertyName "age" -propertyValue 30
```

---
## Append-JsonProperty

Appends a new property to a JSON object. The new property is added after the last existing property, maintaining the order of the properties. This function is useful for incrementally building up a JSON object.

| Argument     | Type   | Mandatory | Description                                          | Example Value                                    |
|--------------|--------|-----------|------------------------------------------------------|--------------------------------------------------|
| jsonObject   | object | Yes       | The JSON object to which the new property will be appended | `ConvertFrom-Json '{"B": "ValueB", "C": "ValueC"}'` |
| propertyName | string | Yes       | The name of the new property to be appended           | 'D'                                              |
| propertyValue| *      | Yes       | The value of the new property to be appended         | 'ValueD'                                         |

Usage:

```powershell
$jsonObject = @{ "B" = "ValueB"; "C" = "ValueC" }
Append-JsonProperty -jsonObject $jsonObject -propertyName "D" -propertyValue "ValueD"
```

---

## Select-JsonTokens

Selects specific elements from a JSON object based on a list of tokens. This function is beneficial for filtering and extracting parts of JSON objects.

| Argument   | Type     | Mandatory | Example Value         |
|------------|----------|-----------|-----------------------|
| jsonObject | object   | Yes       | `ConvertFrom-Json '{"name": "John", "age": 30, "city": "New York"}'` |
| tokens     | string[] | Yes       | @('name', 'city')     |

```powershell
$selectedJson = Select-JsonTokens -jsonObject $jsonObject -tokens @("name", "city")
```

---

## Find-JsonPropertyInstances

Searches through a JSON object and returns all instances (parents) where the specified property is found, including nested objects. This function is useful for identifying all occurrences of a specific property within a complex JSON structure.

| Argument     | Type   | Mandatory | Description                                      | Example Value                                    |
|--------------|--------|-----------|--------------------------------------------------|--------------------------------------------------|
| jsonObject   | object | Yes       | The JSON object in which to search for the property | `ConvertFrom-Json '{ "000001": { "name": "Luke", "age": "16", "contacts": {"email": "luke@email.com", "phone": "+39 1234567"} }, "000002": { "name": "Tom", "age": "16", "contacts": {"email": "tom@email.com", "phone": "+39 1234568" } }'` |
| propertyName | string | Yes       | The name of the property to search for in the JSON object | 'email'                                          |

Usage:

```powershell
$jsonObject = ConvertFrom-Json '{ "000001": { "name": "Luke", "age": "16", "contacts": {"email": "luke@email.com", "phone": "+39 1234567"} }, "000002": { "name": "Tom", "age": "16", "contacts": {"email": "tom@email.com", "phone": "+39 1234568" } }'
$propertyName = "email"
$instances = Find-JsonPropertyInstances -jsonObject $jsonObject -propertyName $propertyName
Write-Host "Instances Found: $($instances | ConvertTo-Json -Depth 100)"
```
---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>