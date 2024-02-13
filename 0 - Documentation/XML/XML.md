# XML.ps1 Function Documentation

The `xml.ps1` file in the NoModulePowershell library is a robust and versatile toolkit designed to streamline the handling of XML data within PowerShell environments. This file comprises a comprehensive set of functions specifically aimed at simplifying the complexities associated with XML file manipulation, parsing, and data conversion.


## List of Functions

1. [Test-XMLString](#Test-XMLString) 
2. [Create-XmlDocument](#Create-XmlDocument) 
3. [Get-XmlElement](#Get-XmlElement)
3. [Set-XmlElement](#Set-XmlElement)
4. [Add-XmlElement](#Add-XmlElement)
5. [Update-XmlElement](#Update-XmlElement)
5. [Remove-XmlElement](#Remove-XmlElement)
6. [Merge-XmlDocuments](#Merge-XmlDocuments)
7. [Convert-XmlToJson](#Convert-XmlToJson)
8. [Convert-XmlToPSCustomObject](#Convert-XmlToPSCustomObject)
9. [Validate-XmlAgainstXsd](#Validate-XmlAgainstXsd)
10. [Export-XmlData](#Export-XmlData)
11. [Format-Xml](#Format-Xml)

---

## Test-XMLString

Validates a string as a well-formed XML.

| Argument  | Type   | Mandatory | Description                          | Example Value                              |
|-----------|--------|-----------|--------------------------------------|--------------------------------------------|
| XmlString | string | Yes       | The XML string to validate           | `'<books><book>...</book></books>'`        |

Usage:

To validate a string as a well-formed XML:

```powershell
$xmlString = @"
<books>
  <book><title>Book One</title></book>
</books>
"@
$result = Test-XMLString -XmlString $xmlString
Write-Host "Is valid XML: $result"
```

---

## Create-XmlDocument

Creates a new XML document with a specified root element. Optional attributes and content for the root element can also be added.

| Argument   | Type     | Mandatory | Description                                         | Example Value                                        |
|------------|----------|-----------|-----------------------------------------------------|------------------------------------------------------|
| RootElement| string   | Yes       | The name of the root element in the XML document    | `'books'`                                            |
| Attributes | hashtable| No        | Optional hashtable of attributes for the root element | `@{ "version" = "1.0"; "encoding" = "UTF-8" }`      |
| Content    | string   | No        | Optional content to add within the root element     | `'This is some sample content'`                      |

Usage:

To create a new XML document with a root element and optional attributes, and then print the resulting XML:

```powershell
$attributes = @{ "version" = "1.0"; "encoding" = "UTF-8" }
$doc = Create-XmlDocument -RootElement "books" -Attributes $attributes
Write-Output $doc.OuterXml
```

---

## Get-XmlElement

Retrieves XML elements using XPath from an XML document.

### Arguments

| Argument             | Type     | Mandatory | Description                                   | Example Value                         |
|----------------------|----------|-----------|-----------------------------------------------|---------------------------------------|
| `XmlContent`         | `xml`    | Yes       | The XML content to query.                     | `'<books><book>...</book></books>'`   |
| `XPath`              | `string` | Yes       | The XPath expression to locate nodes in XML.  | `'//book/title'`                      |
| `XmlNamespaceManager`| `string` | No        | (Optional) The XmlNamespaceManager to use for resolving namespaces in XPath. |           |

### Usage

To extract all `<book>` elements and print their titles:

```powershell
$xml = [xml]@"
<books>
  <book><title>Book One</title></book>
  <book>
    <title>Book Two</title>
    <desc>Book Two Description</desc>
  </book>
  <magazine>
    <title>Magazine</title>
    <desc>Magazine Description</desc>
  </magazine>
</books>
"@
$books = Get-XmlElement -XmlContent $xml -XPath '//book'
foreach ($book in $books) {
    "[BOOK] Title: $($book.title.InnerText)"
}
```

To extract the `<desc>` element of `<magazine>` and print its content:

```powershell
$magazineDesc = Get-XmlElement -XmlContent $xml -XPath '//magazine/desc'
foreach ($desc in $magazineDesc) {
    "[MAGAZINE] Description: $($desc.InnerText)"
}
```

---

## Set-XmlElement

Sets or updates the value of an XML element using an XPath expression.

| Argument  | Type   | Mandatory | Description                             | Example Value                          |
|-----------|--------|-----------|-----------------------------------------|----------------------------------------|
| XmlContent| xml    | Yes       | The XML content to be modified          | `'<books><book>...</book></books>'`    |
| XPath     | string | Yes       | The XPath expression to locate the element | `'/books/book/title'`                  |
| NewValue  | string | Yes       | The new value to set for the XML element | `'New Title'`                          |

Usage:

To set or update the value of an XML element:

```powershell
$xml = [xml]@"
<books>
  <book><title>Old Title</title></book>
</books>
"@
Set-XmlElement -XmlContent $xml -XPath '/books/book/title' -NewValue 'New Title'
$xml.OuterXml
```

---

## Add-XmlElement

Adds a new element to an XML document at a specified location.

| Argument       | Type     | Mandatory | Description                             | Example Value                      |
|----------------|----------|-----------|-----------------------------------------|------------------------------------|
| XmlContent     | xml      | Yes       | The XML content to be modified          | `'<books><book>...</book></books>'`|
| ParentXPath    | string   | Yes       | The XPath expression to locate the parent element | `'/books'`                      |
| NewElementName | string   | Yes       | The name of the new element to add      | `'book'`                           |
| NewElementValue| string   | No        | Optional value for the new element      | `'Book Two'`                       |
| Attributes     | hashtable| No        | Optional hashtable of attributes for the new element | `@{ "id" = "2" }`             |

Usage:

To add a new element to an XML document:

```powershell
$xml = [xml]@"
<books>
  <book><title>Book One</title></book>
</books>
"@
Add-XmlElement -XmlContent $xml -ParentXPath '/books' -NewElementName 'book' -NewElementValue 'Book Two'
$xml.OuterXml
```


---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>
