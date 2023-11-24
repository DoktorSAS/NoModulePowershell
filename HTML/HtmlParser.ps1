<#
.SYNOPSIS
Gets elements by ID from an HTML string.

.DESCRIPTION
This function retrieves elements from an HTML string using the specified ID. 
If multiple elements have the same ID, they are returned as a list.
If the InnerContent switch is used, only the inner content of the tags is returned.

.PARAMETER HtmlString
The HTML string to parse.

.PARAMETER Id
The ID of the HTML element to find.

.PARAMETER InnerContent
Return only the inner content of the HTML element.

.EXAMPLE
$html = @"
<div id='uniqueId'>Content1</div>
<div id='duplicateId'>Content2</div>
<div id='duplicateId'>Content3</div>
"@
Get-HtmlElementById -HtmlString $html -Id 'duplicateId' -InnerContent
#>

function Get-HtmlElementById {
    param (
        [Parameter(Mandatory=$true)]
        [string]$HtmlString,

        [Parameter(Mandatory=$true)]
        [string]$Id,

        [Parameter(Mandatory=$false)]
        [switch]$InnerContent
    )

    $pattern = "<[^>]*id=['""]?$Id['""]?[^>]*>(.*?)</[^>]+>"
    $matches = [regex]::Matches($HtmlString, $pattern)

    if ($matches.Count -eq 0) {
        return $null
    }

    $elements = @()
    foreach ($match in $matches) {
        if ($InnerContent) {
            $elements += $matches.Groups[1].Value
        } else {
            $elements += $match.Value
        }
    }

    return $elements -join "`n"
}

<#
.SYNOPSIS
Gets elements by class from an HTML string.

.DESCRIPTION
This function retrieves elements from an HTML string using the specified class. 
If multiple elements have the same class, they are returned as a list.

.PARAMETER HtmlString
The HTML string to parse.

.PARAMETER Class
The class of the HTML elements to find.

.PARAMETER InnerContent
Return only the inner content of the HTML elements.

.EXAMPLE
$html = @"
<div class='info'>Content1</div>
<div class='highlight'>Content2</div>
<div class='info'>Content3</div>
"@
Get-HtmlElementsByClass -HtmlString $html -Class 'info'
#>

function Get-HtmlElementsByClass {
    param (
        [Parameter(Mandatory=$true)]
        [string]$HtmlString,

        [Parameter(Mandatory=$true)]
        [string]$Class,

        [Parameter(Mandatory=$false)]
        [switch]$InnerContent
    )

    $pattern = "<[^>]*class=['""]?$Class['""]?[^>]*>(.*?)</[^>]+>"
    $matches = [regex]::Matches($HtmlString, $pattern)

    $elements = @()
    foreach ($match in $matches) {
        if ($InnerContent) {
            $elements += $match.Groups[1].Value
        } else {
            $elements += $match.Value
        }
    }

    return $elements -join "`n"
}

<#
.SYNOPSIS
Gets elements by tag name from an HTML string.

.DESCRIPTION
This function retrieves elements from an HTML string using the specified tag name.

.PARAMETER HtmlString
The HTML string to parse.

.PARAMETER TagName
The tag name of the HTML elements to find.

.PARAMETER InnerContent
Return only the inner content of the HTML elements.

.EXAMPLE
$html = @"
<p>Content1</p>
<div>Content2</div>
<p>Content3</p>
"@
Get-HtmlElementsByTagName -HtmlString $html -TagName 'p'
#>

function Get-HtmlElementsByTagName {
    param (
        [Parameter(Mandatory=$true)]
        [string]$HtmlString,

        [Parameter(Mandatory=$true)]
        [string]$TagName,

        [Parameter(Mandatory=$false)]
        [switch]$InnerContent
    )

    $pattern = "<$TagName[^>]*>(.*?)</$TagName>"
    $matches = [regex]::Matches($HtmlString, $pattern)

    $elements = @()
    foreach ($match in $matches) {
        if ($InnerContent) {
            $elements += $match.Groups[1].Value
        } else {
            $elements += $match.Value
        }
    }

    return $elements -join "`n"
}

<#
.SYNOPSIS
Extracts meta tags from an HTML string.

.DESCRIPTION
This function parses an HTML string and extracts all meta tags, returning their attributes and content.

.PARAMETER HtmlString
The HTML string to parse.

.EXAMPLE
$html = @"
<head>
    <meta name="description" content="Example of a description">
    <meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
</head>
"@
Get-HtmlMetaTags -HtmlString $html
#>

function Get-HtmlMetaTags {
    param (
        [Parameter(Mandatory=$true)]
        [string]$HtmlString
    )

    $pattern = '<meta\s+([^>]+)>'
    $matches = [regex]::Matches($HtmlString, $pattern)

    $metaTags = @()
    foreach ($match in $matches) {
        $attributesString = $match.Groups[1].Value

        $attributes = @{}
        $attributesString -split '\s+' | ForEach-Object {
            if ($_ -match '(.*?)=["''](.*)["'']') {
                $attributes[$matches[1]] = $matches[2]
            }
        }

        $metaTags += $attributes
    }

    return $metaTags
}
