# HtmlParser.ps1 Function Documentation

The `HtmlParser.ps1` file in the NoModulePowershell library is a versatile and comprehensive tool for parsing and extracting information from HTML content in PowerShell. This collection of functions is specifically designed to navigate and interpret the complexities of HTML, making it easier to access, manipulate, and retrieve desired data from HTML strings.

## List of Functions

1. [Get-HtmlElementById](#Get-HtmlElementById)
2. [Get-HtmlElementsByClass](#Get-HtmlElementsByClass)
3. [Get-HtmlElementsByTagName](#Get-HtmlElementsByTagName)
4. [Get-HtmlMetaTags](#Get-HtmlMetaTags)


---

## Get-HtmlElementById

Gets elements by ID from an HTML string. If multiple elements have the same ID, they are returned as a list. If the InnerContent switch is used, only the inner content of the tags is returned.

| Argument    | Type   | Mandatory | Description                                | Example Value                         |
|-------------|--------|-----------|--------------------------------------------|---------------------------------------|
| HtmlString  | string | Yes       | The HTML string to parse                   | `'<div id="uniqueId">Content</div>'`  |
| Id          | string | Yes       | The ID of the HTML element to find         | `'uniqueId'`                          |
| InnerContent| switch | No        | Return only the inner content of the tag   |                                        |

Usage:

To get elements by ID from an HTML string with only their inner content:

```powershell
$html = @"
<div id='uniqueId'>Content1</div>
<div id='duplicateId'>Content2</div>
<div id='duplicateId'>Content3</div>
"@
$elements = Get-HtmlElementById -HtmlString $html -Id 'duplicateId'
$elements | ForEach-Object { Write-Host $_ }
```

---

## Get-HtmlElementsByClass

Gets elements by class from an HTML string. If multiple elements have the same class, they are returned as a list.

| Argument    | Type   | Mandatory | Description                               | Example Value                         |
|-------------|--------|-----------|-------------------------------------------|---------------------------------------|
| HtmlString  | string | Yes       | The HTML string to parse                  | `'<div class="info">Content</div>'`   |
| Class       | string | Yes       | The class of the HTML elements to find    | `'info'`                              |
| InnerContent| switch | No        | Return only the inner content of the HTML elements |                                       |

Usage:

To get elements by class from an HTML string:

```powershell
$html = @"
<div class='info'>Content1</div>
<div class='highlight'>Content2</div>
<div class='info'>Content3</div>
"@
$elements = Get-HtmlElementsByClass -HtmlString $html -Class 'info'
$elements | ForEach-Object { Write-Host $_ }
```

---

## Get-HtmlElementsByTagName

Gets elements by tag name from an HTML string.

| Argument    | Type   | Mandatory | Description                                  | Example Value                      |
|-------------|--------|-----------|----------------------------------------------|------------------------------------|
| HtmlString  | string | Yes       | The HTML string to parse                     | `'<p>Some content</p>'`            |
| TagName     | string | Yes       | The tag name of the HTML elements to find    | `'p'`                              |
| InnerContent| switch | No        | Return only the inner content of the HTML elements |                                    |

Usage:

To get elements by tag name from an HTML string:

```powershell
$html = @"
<p>Content1</p>
<div>Content2</div>
<p>Content3</p>
"@
$elements = Get-HtmlElementsByTagName -HtmlString $html -TagName 'p'
$elements | ForEach-Object { Write-Host $_ }
```
---

## Get-HtmlMetaTags

Extracts meta tags from an HTML string, returning their attributes and content.

| Argument   | Type   | Mandatory | Description                                | Example Value                                 |
|------------|--------|-----------|--------------------------------------------|-----------------------------------------------|
| HtmlString | string | Yes       | The HTML string to parse                   | `'<head><meta name="description" content="..."></head>'` |

Usage:

To extract meta tags from an HTML string:

```powershell
$html = @"
<head>
    <meta name="description" content="Example of a description">
    <meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
</head>
"@
$metaTags = Get-HtmlMetaTags -HtmlString $html
$metaTags | ForEach-Object { Write-Host $_ }
```

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>