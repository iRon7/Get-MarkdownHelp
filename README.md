# Get-MarkdownHelp
Creates a markdown Readme string from the comment based help of a command
## [Syntax](#syntax)
```PowerShell
Get-MarkdownHelp
    [[-CommandName] <String>]
    [<CommonParameters>]
```
## [Description](#description)
 This cmdlet uses the command information and Get-Help cmdlet to build a markdown Readme  
simular to the general PowerShell online help.

## [Examples](exampls)
### Example 1
```PowerShell
Get-MarkdownHelp Show-MarkDown |Out-String |Show-Markdown -UseBrowser
```
 This command shows a markdown formatted help of the `Show-MarkDown` cmdlet in the default browser.

### Example 2
The following example copies the markdown help to the clipboard:

```PowerShell
Get-MarkdownHelp Get-Content |Clip
```

 This command creates a markdown readme string for the Get-Content cmdlet and put it on the clipboard  
to be used e.g. pasting it into a GitHub readme file.

### Example 3
```PowerShell
Get-MarkdownHelp .\MyScript.ps1 |Set-Content .\Readme.md
```
 This command creates a markdown readme string for the .\MyScript.ps1 script and saves it in Readme.md.

## [Parameters](#parameters)
### `-CommandName`
| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 1 |
| Default value:              |  |
| Accept pipeline input:      | true (ByValue, ByPropertyName) |
| Accept wildcard characters: | false |
## [Inputs](#inputs)
### [String](https://docs.microsoft.com/en-us/dotnet/api/System.String)
## [Outputs](#outputs)
### [String[]](https://docs.microsoft.com/en-us/dotnet/api/System.String[])
## [Related Links](#related-links)
* [https://github.com/iRon7/Get-MarkdownHelp](https://github.com/iRon7/Get-MarkdownHelp)
