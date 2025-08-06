<!-- markdownlint-disable MD033 -->
# Get-MarkdownHelp

Creates a markdown Readme document from the comment based help of a PowerShell command

## Syntax

```PowerShell
Get-MarkdownHelp
    -Path <Object>
    [-Command <Object>]
    [<CommonParameters>]
```

```PowerShell
Get-MarkdownHelp
    -ScriptBlock <Object>
    [-Command <Object>]
    [<CommonParameters>]
```

```PowerShell
Get-MarkdownHelp
    [-PSCodePattern <String> = 'PS.*\>\s?']
    [-AlternateEOL <String> = '\']
    [<CommonParameters>]
```

## Description

The [Get-MarkdownHelp][1] cmdlet retrieves the [comment-based help][2] and converts it to a Markdown page
similar to the general online PowerShell help pages (as e.g. [`Get-Content`](https://go.microsoft.com/fwlink/?LinkID=2096490)).  
Note that this cmdlet *doesn't* support `XML`-based help files, but has a few extra features for the
comment-based help as opposed to the native [platyPS][3] [`New-MarkdownHelp`](https://github.com/PowerShell/platyPS/blob/master/docs/New-MarkdownHelp.md):

### Code Blocks

To create code blocks, indent every line of the block by at least four spaces or one tab relative the
**text indent**.
The **text indent** is defined by the smallest indent of the current - and the `.SYNOPSIS` section.  
Code blocks are automatically [fenced][4] for default PowerShell color coding.  
The usual comment-based help prefix for code (`PS. \>`) might also be used to define a code lines.
For more details, see the [`-PSCodePattern` parameter](#-pscodepattern).

As defined by the standard help interpreter, code blocks (including fenced code blocks) can't include help
keywords. Meaning (fenced) code blocks will end at the next section defined by `.<help keyword>`.

### Titled Examples

Examples can be titled by adding an (extra) hash (`#`) in front of the first line in the section.
This line will be removed from the section and added to the header of the example.

### Links

As per markdown definition:
> The first part of a [reference-style link][5] is formatted with two sets of brackets.
> The first set of brackets surrounds the text that should appear linked. The second set of brackets displays
> a label used to point to the link you're storing elsewhere in your document, e.g.: `[rabbit-hole][1]`.
> The second part of a reference-style link is formatted with the following attributes:
>
> * The label, in brackets, followed immediately by a colon and at least one space (e.g., `[label]:` ).
> * The URL for the link, which you can optionally enclose in angle brackets.
> * The optional title for the link, which you can enclose in double quotes, single quotes, or parentheses.

For the comment-base help implementation, the second part should be placed in the `.LINK` section to automatically
listed in the end of the document. The reference will be hidden if the label is an explicit empty string(`""`).

### Quick Links

Any phrase existing of a combination alphanumeric characters, spaces, underscores and hyphen characters
between squared brackets, e.g. `[my link]`) will be automatically linked to the anchor id in the document, e.g.:
`[my link](#my-link)`.

> [!WARNING](#-warning)
> There is no check whether the internal anchor id actually exists.

#### Example links

**Example links** are similar to **Quick Links** but start with a the word "example" followed by the example
index, e.g.: `[example 1]`, or example caption, e.g.: `[example "Display markdown help"]`. Where the caption is
identified by converting its consecutive non-word characters to a single hyphen.

**Examples:**
* `[example 1]` will link to the first [example 1](#example-1) in this document
* `[example 2 with any caption]` will link to the second [example 2 (regardless the caption)](#example-2) in this document
* `[example "Save markdown help to file"]` will link to the [example "Save markdown help to file"](#example-save-markdown-help-to-file-) in this document

#### Parameter Links

**Parameter links** are similar to **Quick Links** but start with a hyphen and contain an existing parameter
name possibly followed by the word "parameter". E.g.: `[-AlternateEOL]` or `[-AlternateEOL parameter]`.
In this example, the parameter link will refer to the internal [`-AlternateEOL` parameter](#-alternateeol).

#### Cmdlet Links

**Cmdlet links** are similar to **Quick Links** but contain a cmdlet name where the online help is known. E.g.: `[Get-Content]`.
In this example, the cmdlet link will refer to the online help of the related [`Get-Content`](https://go.microsoft.com/fwlink/?LinkID=2096490) cmdlet.

## Examples

### <a id="example-1"><a id="example-display-markdown-help">Example 1: Display markdown help</a></a>

This example generates a markdown format help page from itself and shows it in the default browser

```PowerShell
.\Get-MarkdownHelp.ps1 .\Show-MarkDown.ps1 | Out-String | Show-Markdown -UseBrowser
```

### <a id="example-2"><a id="example-copy-markdown-help-to-a-website">Example 2: Copy markdown help to a website</a></a>

This command creates a markdown readme string for the `Join-Object` cmdlet and puts it on the clipboard
so that it might be pasted into e.g. a GitHub readme file.

```PowerShell
Get-MarkdownHelp Join-Object | Clip
```

### <a id="example-3"><a id="example-save-markdown-help-to-file">Example 3: Save markdown help to file</a></a>

This command creates a markdown readme string for the `.\MyScript.ps1` script and saves it in `Readme.md`.

```PowerShell
Get-MarkdownHelp .\MyScript.ps1 | Set-Content .\Readme.md
```

## Parameters

### <a id="-path">`-Path <Object>`</a>

An embedded command that contains the parameters or actual commented help.

| [Parameter](#-path) | -Path |
| :- | - |
| Aliases | Source |
| Type | <a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a> |
| Mandatory | True |
| Position | Named |
| Default value |  |
| Accept pipeline input | False |
| Accept wildcard characters | False |

### <a id="-scriptblock">`-ScriptBlock <Object>`</a>

The script content that contains the commented help.

| [Parameter](#-scriptblock) | -ScriptBlock |
| :- | - |
| Aliases |  |
| Type | <a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a> |
| Mandatory | True |
| Position | Named |
| Default value |  |
| Accept pipeline input | False |
| Accept wildcard characters | False |

### <a id="-command">`-Command <Object>`</a>

| [Parameter](#-command) | -Command |
| :- | - |
| Aliases |  |
| Type | <a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a> |
| Mandatory | False |
| Position | Named |
| Default value |  |
| Accept pipeline input | False |
| Accept wildcard characters | False |

### <a id="-pscodepattern">`-PSCodePattern <String>`</a>

Specifies the PowerShell code pattern used by the get-help cmdlet.
The native [`Get-Help`] cmdlet automatically adds a PowerShell prompt (`PS \>`) to the first line of an example if not yet exist.
To be consistent with the first line you might manually add a PowerShell prompt to each line of code which will be converted to
a code block by this `Get-MarkdownHelp` cmdlet.

| [Parameter](#-pscodepattern) | -PSCodePattern |
| :- | - |
| Aliases |  |
| Type | <a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a> |
| Mandatory | False |
| Position | Named |
| Default value | <code>'PS.*\>\s?'</code> |
| Accept pipeline input | False |
| Accept wildcard characters | False |

### <a id="-alternateeol">`-AlternateEOL <String>`</a>

The recommended way to force a line break or new line (`<br>`) in markdown is to end a line with two or more spaces but as that
might cause an *[Avoid Trailing Whitespace][7]* warning, you might also consider to use an alternate EOL marker.  
Any alternate EOL marker (at the end of the line) will be replaced by two spaces by this `Get-MarkdownHelp` cmdlet.

| [Parameter](#-alternateeol) | -AlternateEOL |
| :- | - |
| Aliases |  |
| Type | <a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a> |
| Mandatory | False |
| Position | Named |
| Default value | <code>'\'</code> |
| Accept pipeline input | False |
| Accept wildcard characters | False |

## Inputs

A (reference to a) command or module

## Outputs

`String[]`

## Related Links

* [Online Help](https://github.com/iRon7/Get-MarkdownHelp)
* [About comment based help](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help)
* [PlatyPS MALM renderer](https://github.com/PowerShell/platyPS)
* [Fenced Code Blocks](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks)
* [Reference-style Links](https://www.markdownguide.org/basic-syntax/#reference-style-links)
* https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidtrailingwhitespace
<!-- -->

* [Markdown guide](https://www.markdownguide.org/basic-syntax/)
<!-- -->


[1]: https://github.com/iRon7/Get-MarkdownHelp "Online Help"
[2]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help "About comment based help"
[3]: https://github.com/PowerShell/platyPS "PlatyPS MALM renderer"
[4]: https://www.markdownguide.org/extended-syntax/#fenced-code-blocks "Fenced Code Blocks"
[5]: https://www.markdownguide.org/basic-syntax/#reference-style-links "Reference-style Links"
[7]: https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidtrailingwhitespace ""

[comment]: <> (Created with Get-MarkdownHelp: Install-Script -Name Get-MarkdownHelp)
