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
