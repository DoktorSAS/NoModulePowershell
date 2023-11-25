<#
.SYNOPSIS
Validates a string as a well-formed XML.

.DESCRIPTION
This function tests if a given string is a well-formed XML. It returns $true if the string is a valid XML, otherwise $false.

.PARAMETER XmlString
The XML string to validate.

.EXAMPLE
$xmlString = @"
<books>
  <book><title>Book One</title></book>
</books>
"@
$result = Test-XMLString -XmlString $xmlString
Write-Host "Is valid XML: $result"
#>

function Test-XMLString {
    param (
        [Parameter(Mandatory=$true)]
        [string]$XmlString
    )

    try {
        $xmlDocument = New-Object System.Xml.XmlDocument
        $xmlDocument.LoadXml($XmlString)
        return $true
    } catch {
        return $false
    }
}

<#
.SYNOPSIS
Creates a new XML document.

.DESCRIPTION
This function creates a new XML document with a specified root element. Optional attributes and content for the root element can also be added.

.PARAMETER RootElement
The name of the root element in the XML document.

.PARAMETER Attributes
Optional hashtable of attributes to add to the root element.

.PARAMETER Content
Optional content to add within the root element.

.EXAMPLE
$attributes = @{ "version" = "1.0"; "encoding" = "UTF-8" }
$doc = Create-XmlDocument -RootElement "books" -Attributes $attributes
$doc.OuterXml
#>

function Create-XmlDocument {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootElement,

        [Parameter(Mandatory=$false)]
        [hashtable]$Attributes,

        [Parameter(Mandatory=$false)]
        [string]$Content
    )

    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.Indent = $true

    $stringBuilder = New-Object System.Text.StringBuilder
    $xmlWriter = [System.Xml.XmlWriter]::Create($stringBuilder, $xmlWriterSettings)

    $xmlWriter.WriteStartDocument()
    $xmlWriter.WriteStartElement($RootElement)

    if ($Attributes) {
        foreach ($key in $Attributes.Keys) {
            $xmlWriter.WriteAttributeString($key, $Attributes[$key])
        }
    }

    if ($Content) {
        $xmlWriter.WriteString($Content)
    }

    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()

    $xmlDocument = New-Object System.Xml.XmlDocument
    $xmlDocument.LoadXml($stringBuilder.ToString())
    return $xmlDocument
}

<#
.SYNOPSIS
Extracts elements from an XML document by XPath.

.DESCRIPTION
This function retrieves elements from an XML document using an XPath query.

.PARAMETER XmlContent
The XML content to parse.

.PARAMETER XPath
The XPath query to select elements.

.EXAMPLE
$xml = [xml]@"
<books>
  <book><title>Book One</title></book>
  <book>
    <title>Book Two</title>
    <desc>Book Two Description</desc>
  </book>
  <magazine>
    <title>Magazine</title>
    <desc>Magazine Dexription</desc>
  </magazine>
</books>
"@
$elements = Get-XmlElement -XmlContent $xml -XPath '//book/title'
$elements | ForEach-Object { Write-Output $_.InnerText }
#>

function Get-XmlElement {
    param (
        [Parameter(Mandatory=$true)]
        [xml]$XmlContent,

        [Parameter(Mandatory=$true)]
        [string]$XPath
    )

    try {
        $xmlDocument = [System.Xml.XmlDocument]::new()
        $xmlDocument.LoadXml($XmlContent.OuterXml)
        $nodes = $xmlDocument.SelectNodes($XPath)
        return $nodes
    } catch {
        Write-Error "An error occurred: $_"
        return $null
    }
}

<#
.SYNOPSIS
Sets or updates the value of an XML element.

.DESCRIPTION
This function sets or updates the value of a specified XML element using an XPath expression.

.PARAMETER XmlContent
The XML content to be modified.

.PARAMETER XPath
The XPath expression to locate the element.

.PARAMETER NewValue
The new value to set for the specified XML element.

.EXAMPLE
$xml = [xml]@"
<books>
  <book><title>Old Title</title></book>
</books>
"@
Set-XmlElement -XmlContent $xml -XPath '/books/book/title' -NewValue 'New Title'
$xml.OuterXml
#>

function Set-XmlElement {
    param (
        [Parameter(Mandatory=$true)]
        [xml]$XmlContent,

        [Parameter(Mandatory=$true)]
        [string]$XPath,

        [Parameter(Mandatory=$true)]
        [string]$NewValue
    )

    $node = $XmlContent.SelectSingleNode($XPath)
    if ($node -ne $null) {
        $node.InnerText = $NewValue
        return $XmlContent
    } else {
        Write-Error "Element not found with the XPath: $XPath"
        return $null
    }
}

<#
.SYNOPSIS
Adds ied location in an XML document.
a new XML element to a specif
.DESCRIPTION
This function adds a new element to an XML document at the location specified by an XPath expression.

.PARAMETER XmlContent
The XML content to be modified.

.PARAMETER ParentXPath
The XPath expression to locate the parent element.

.PARAMETER NewElementName
The name of the new element to add.

.PARAMETER NewElementValue
Optional value for the new element.

.PARAMETER Attributes
Optional hashtable of attributes for the new element.

.EXAMPLE
$xml = [xml]@"
<books>
  <book><title>Book One</title></book>
</books>
"@
Add-XmlElement -XmlContent $xml -ParentXPath '/books' -NewElementName 'book' -NewElementValue 'Book Two'
$xml.OuterXml
#>

function Add-XmlElement {
    param (
        [Parameter(Mandatory=$true)]
        [xml]$XmlContent,

        [Parameter(Mandatory=$true)]
        [string]$ParentXPath,

        [Parameter(Mandatory=$true)]
        [string]$NewElementName,

        [Parameter(Mandatory=$false)]
        [string]$NewElementValue,

        [Parameter(Mandatory=$false)]
        [hashtable]$Attributes
    )

    $parentNode = $XmlContent.SelectSingleNode($ParentXPath)
    if ($parentNode -eq $null) {
        Write-Error "Parent element not found with the XPath: $ParentXPath"
        return $null
    }

    $newElement = $XmlContent.CreateElement($NewElementName)
    if ($NewElementValue) {
        $newElement.InnerText = $NewElementValue
    }

    if ($Attributes) {
        foreach ($key in $Attributes.Keys) {
            $attr = $XmlContent.CreateAttribute($key)
            $attr.Value = $Attributes[$key]
            $newElement.SetAttributeNode($attr)
        }
    }

    $parentNode.AppendChild($newElement)
    return $XmlContent
}
