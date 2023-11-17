# Json.ps1 Function Documentation

The `Json.ps1` file in the NoModulePowershell library provides a suite of functions designed to enhance and simplify the handling of JSON data in PowerShell scripts. These functions offer a more intuitive and error-resistant approach to JSON manipulation, ensuring clear and predictable behaviors. The file is tailored to support a wide range of common JSON operations, from basic parsing and property manipulation to more advanced data selection and validation techniques.

## List of Functions

1. [Test-JsonString](#test-jsonstring)
2. [Set-JsonProperty](#set-jsonproperty)
3. [Get-JsonProperty](#get-jsonproperty)
4. [Add-JsonProperty](#add-jsonproperty)
5. [Select-JsonTokens](#select-jsontokens)

---

## Test-JsonString

This function checks if a provided string is a valid JSON object. It's useful for validating JSON data before attempting to parse or manipulate it, thereby preventing errors due to invalid JSON formats.

| Argument    | Type   | Mandatory | Example Value             |
|-------------|--------|-----------|---------------------------|
| jsonString  | string | Yes       | '{"name": "John", "age": 30}' |

```
$isValid = Test-JsonString -jsonString $jsonString
```

If `$isValid` is `true`, the string is a valid JSON object; if `false`, it is not.

---

## Set-JsonProperty

Sets the value of a specified property in a JSON object. This function is useful for modifying JSON objects dynamically.

| Argument    | Type   | Mandatory | Example Value             |
|-------------|--------|-----------|---------------------------|
| jsonObject  | object | Yes       | `ConvertFrom-Json '{"name": "John", "age": 30}'` |
| propertyName| string | Yes       | 'age'                     |
| newValue    | object | Yes       | 31                        |

```
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

```
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

```
Add-JsonProperty -jsonObject $jsonObject -propertyName "age" -propertyValue 30
```

---

## Select-JsonTokens

Selects specific elements from a JSON object based on a list of tokens. This function is beneficial for filtering and extracting parts of JSON objects.

| Argument   | Type     | Mandatory | Example Value         |
|------------|----------|-----------|-----------------------|
| jsonObject | object   | Yes       | `ConvertFrom-Json '{"name": "John", "age": 30, "city": "New York"}'` |
| tokens     | string[] | Yes       | @('name', 'city')     |

```
$selectedJson = Select-JsonTokens -jsonObject $jsonObject -tokens @("name", "city")
```

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>