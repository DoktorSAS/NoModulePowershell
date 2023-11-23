# XML.ps1 Function Documentation

The `xml.ps1`` file in the NoModulePowershell library is a robust and versatile toolkit designed to streamline the handling of XML data within PowerShell environments. This file comprises a comprehensive set of functions specifically aimed at simplifying the complexities associated with XML file manipulation, parsing, and data conversion.


## List of Functions

1. [Convert-XmlToJson](#Convert-XmlToJson) - Converte un file XML in un oggetto JSON.
2. [Get-XmlElement](#Get-XmlElement) - Estrae elementi specifici da un file XML.
3. [Add-XmlElement](#Add-XmlElement) - Aggiunge nuovi elementi a un file XML esistente.
4. [Remove-XmlElement](#Remove-XmlElement) - Rimuove elementi specifici da un file XML.
5. [Update-XmlElement](#Update-XmlElement) - Aggiorna o modifica elementi e attributi esistenti in un file XML.
6. [Convert-XmlToPSCustomObject](#Convert-XmlToPSCustomObject) - Converte un file XML in un oggetto PowerShell personalizzato.
7. [Validate-XmlAgainstXsd](#Validate-XmlAgainstXsd) - Valida un file XML rispetto a uno schema XSD.
8. [Export-XmlData](#Export-XmlData) - Esporta dati da un file XML in altri formati come CSV o Excel.
9. [Merge-XmlDocuments](#Merge-XmlDocuments) - Combina più documenti XML in un unico file.
10. [Format-Xml](#Format-Xml) - Formatta o indenta un file XML per migliorarne la leggibilità.

---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>

curl 'https://github.githubassets.com/assets/vendors-node_modules_github_catalyst_lib_index_js-node_modules_github_hydro-analytics-client_-978abc0-15861e0630b6.js' \
  -H 'sec-ch-ua: "Google Chrome";v="119", "Chromium";v="119", "Not?A_Brand";v="24"' \
  -H 'Referer: https://github.com/' \
  -H 'Origin: https://github.com' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua-platform: "Windows"' \
  --compressed