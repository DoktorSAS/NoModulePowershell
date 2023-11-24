# XML.ps1 Function Documentation

The `xml.ps1` file in the NoModulePowershell library is a robust and versatile toolkit designed to streamline the handling of XML data within PowerShell environments. This file comprises a comprehensive set of functions specifically aimed at simplifying the complexities associated with XML file manipulation, parsing, and data conversion.


## List of Functions

1. [Create-XmlDocument](#Create-XmlDocument) 
2. [Get-XmlElement](#Get-XmlElement)
3. [Add-XmlElement](#Add-XmlElement)
4. [Update-XmlElement](#Update-XmlElement)
5. [Remove-XmlElement](#Remove-XmlElement)
6. [Merge-XmlDocuments](#Merge-XmlDocuments)
7. [Convert-XmlToJson](#Convert-XmlToJson)
8. [Convert-XmlToPSCustomObject](#Convert-XmlToPSCustomObject)
9. [Validate-XmlAgainstXsd](#Validate-XmlAgainstXsd)
10. [Export-XmlData](#Export-XmlData)
11. [Format-Xml](#Format-Xml)

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

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>
