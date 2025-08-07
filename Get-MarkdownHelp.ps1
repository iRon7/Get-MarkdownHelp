<#PSScriptInfo
.VERSION 1.2.0
.GUID 19631007-c07a-48b9-8774-fcea5498ddb9
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS Help MarkDown ReadMe
.LICENSE https://github.com/iRon7/Get-MarkdownHelp/LICENSE
.PROJECTURI https://github.com/iRon7/Get-MarkdownHelp
.ICON
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.SYNOPSIS
Creates a markdown Readme document from the comment based help of a PowerShell command

.DESCRIPTION
The [Get-MarkdownHelp][1] cmdlet retrieves the [comment-based help][2] and converts it to a Markdown page
similar to the general online PowerShell help pages (as e.g. [Get-Content]).\
Note that this cmdlet *doesn't* support `XML`-based help files, but has a few extra features for the
comment-based help as opposed to the native [platyPS][3] [New-MarkdownHelp]:

### Code Blocks

To create code blocks, indent every line of the block by at least four spaces or one tab relative the
**text indent**.
The **text indent** is defined by the smallest indent of the current - and the `.SYNOPSIS` section.\
Code blocks are automatically [fenced][4] for default PowerShell color coding.\
The usual comment-based help prefix for code (`PS. \>`) might also be used to define a code lines.
For more details, see the [-PSCodePattern parameter].

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

Any phrase between squared brackets, e.g. `[my link]`, will be automatically linked to the element where the
id is defined by the enclosed phrase and converting the consecutive non-word characters to a single hyphen
(and removing any outer hyphens). In this example: `[my link](#my-link)`

> [!WARNING]
> There is no check whether the internal anchor id actually exists.

#### Example links

**Example links** are based on **Quick Links** but start with a the word "example" followed by the example
index (possibly separated by a space) or the word "example" followed by the example caption.
Where the caption is used to identify the link by converting its consecutive non-word characters to a single hyphen.

**Examples:**
* `[example 1]` will link to the first ([example 1]) in this document
* `[example 2 with any caption]` will link to the second ([example 2 -regardless the caption-]) in this document
* `[example "Save markdown help to file"]` will link to the ([example "Save markdown help to file"]) in this document

#### Parameter Links

**Parameter links** are similar to **Quick Links** but start with a hyphen and contain an existing parameter
name possibly followed by the word "parameter". E.g.: `[-AlternateEOL]` or `[-AlternateEOL parameter]`.
In this example, the parameter link will refer to the internal [-AlternateEOL parameter].

#### Cmdlet Links

**Cmdlet links** are similar to **Quick Links** but contain a cmdlet name where the online help is known. E.g.: `[Get-Content]`.
In this example, the cmdlet link will refer to the online help of the related [Get-Content] cmdlet.

.INPUTS
A (reference to a) command or module

.OUTPUTS
`String[]`


.PARAMETER Path
An embedded command that contains the parameters or actual commented help.

.PARAMETER ScriptBlock
The script content that contains the commented help.

.PARAMETER Command
A specific command or function contained by the script file of block.

.PARAMETER PSCodePattern
Specifies the PowerShell code pattern used by the get-help cmdlet.
The native [`Get-Help`] cmdlet automatically adds a PowerShell prompt (`PS \>`) to the first line of an example if not yet exist.
To be consistent with the first line you might manually add a PowerShell prompt to each line of code which will be converted to
a code block by this `Get-MarkdownHelp` cmdlet.

.PARAMETER AlternateEOL
The recommended way to force a line break or new line (`<br>`) in markdown is to end a line with two or more spaces but as that
might cause an *[Avoid Trailing Whitespace][7]* warning, you might also consider to use an alternate EOL marker.\
Any alternate EOL marker (at the end of the line) will be replaced by two spaces by this `Get-MarkdownHelp` cmdlet.

.EXAMPLE
# Display markdown help
This example generates a markdown format help page from itself and shows it in the default browser

    .\Get-MarkdownHelp.ps1 .\Show-MarkDown.ps1 | Out-String | Show-Markdown -UseBrowser

.EXAMPLE
# Copy markdown help to a website
This command creates a markdown readme string for the `Join-Object` cmdlet and puts it on the clipboard
so that it might be pasted into e.g. a GitHub readme file.

    Get-MarkdownHelp Join-Object | Clip

.EXAMPLE
# Save markdown help to file
This command creates a markdown readme string for the `.\MyScript.ps1` script and saves it in `Readme.md`.

    Get-MarkdownHelp .\MyScript.ps1 | Set-Content .\Readme.md

.LINK
[1]: https://github.com/iRon7/Get-MarkdownHelp "Online Help"
[2]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help "About comment based help"
[3]: https://github.com/PowerShell/platyPS "PlatyPS MALM renderer"
[4]: https://www.markdownguide.org/extended-syntax/#fenced-code-blocks "Fenced Code Blocks"
[5]: https://www.markdownguide.org/basic-syntax/#reference-style-links "Reference-style Links"
[7]: https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidtrailingwhitespace ""

https://www.markdownguide.org/basic-syntax/ "Markdown guide"
#>

using namespace System.Collections.Generic
using NameSpace System.Management.Automation
using NameSpace System.Management.Automation.Language

[CmdletBinding(DefaultParameterSetName = 'Path')][OutputType([String[]])] param(
    [Parameter(Mandatory, ParameterSetName = 'Path', Position = 0)]
    [Parameter(ValueFromPipeLine = $True, ValueFromPipelineByPropertyName = $True)]
    [Alias('Source')]$Path,

    [Parameter(Mandatory, ParameterSetName = 'Script', Position = 0)]
    [Parameter(ValueFromPipelineByPropertyName = $True)]
    $ScriptBlock,

    [Parameter(ValueFromPipelineByPropertyName = $True)]
    $Command,

    [String]$PSCodePattern = 'PS.*\>\s?',

    [String]$AlternateEOL = '\'
)

begin {
    enum MDBlock {
        None
        Text
        Code
        Fenced
    }
    $TabSize = 4
    $Tab = ' ' * $TabSize
    $CodePrefix = "(?<=^\s*)$PSCodePattern"

    $UriLabelPattern  = '\[(?<Label>.+)\]\:'
    $UriPattern       = '\<?(?<Uri>\w+://\S+)\>?'
    $UriTitlePattern  = '("(?<Title>.*)"|''(?<Title>.*)''|\((?<Title>.?)\))'
    $ReferencePattern = "^($UriLabelPattern\s+)?$UriPattern(\s+$UriTitlePattern)?$"
    $AlternateEOL     = [regex]::Escape($AlternateEOL) + '\s*$'

    Class Sentence {
        [Int]$Offset
        [string]$Text
        static [Int]$TabSize = $TabSize
        Sentence([String]$String) {
            $This.Text = $String.Trim()
            if ($This.Text) {
                for ($i = 0; $i -lt $String.Length; $i++) {
                    switch ($String[$i]) {
                        ' '     { $This.Offset++ }
                        "`t"    { $This.Offset = $This.Offset - $This.Offset % [Sentence]::TabSize + [Sentence]::TabSize }
                        Default { $i = $String.Length }
                    }
                }
            }
        }
        [string]Indent([Int]$Offset) {
            $Spaces = [Math]::Max(0, ($This.Offset + $Offset))
            return ' ' * $Spaces + $This.Text
        }
    }

    function StopError($Exception, $Id = 'IncorrectArgument', $Group = [Management.Automation.ErrorCategory]::SyntaxError, $Object){
        if ($Exception -isnot [Exception]) { $Exception = [ArgumentException]$Exception }
        $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($Exception, $Id, $Group, $Object))
    }

    function GetHelpItems([String[]]$Lines) {
        $Key, $Item = $Null
        $Help = @{}
        foreach ($Line in $Lines) {
            $Sentence = [Sentence]($Line -Replace $CodePrefix, $Tab)
            switch ($Sentence.Text) {
                { '.Synopsis', '.Description', '.Inputs', '.Outputs', '.Notes', '.Link' -eq $_ } {
                    $Key = $_.SubString(1)
                    $Item = $Help[$Key] = [List[Sentence]]::new()
                }
                '.Example' {
                    if (!$Help.Contains('Example')) { $Help['Example'] = @{} }
                    $Index = $Help['Example'].Count + 1
                    $Item = $Help['Example'][$Index] = [List[Sentence]]::new()
                }
                { $_ -Like '.Parameter *' } {
                    if (!$Help.Contains('Parameter')) { $Help['Parameter'] = @{} }
                    $Name = ($_ -Split '\.Parameter\s+', 2)[1]
                    $Item = $Help['Parameter'][$Name] = [List[Sentence]]::new()
                }
                Default {
                    if ($Null -ne $Item) { if ($Item.Count -Or $Sentence.Text) { $Item.add($Sentence) } }
                    elseif (!$_) { break }
                }
            }
        }
        $Help
    }

    function GetCommentedHelp([String]$Content) {
        $Comments = [List[String]]::new()
        $Tokens = [PSParser]::Tokenize($Content, [Ref]$Null)
        $Index = 0
        do {
            $Token = if ($Index -lt $Tokens.Count) { $Tokens[$Index++] }
            if ($Token -and $Token.Type -eq 'Comment') {
                if ($Token.Content.StartsWith('#') ) {
                    $Comments.Add($Token.Content.SubString(1))
                }
                else { #Block Comment
                    $Lines = $Token.Content -split '\r?\n'
                    if (-not $Lines) { Throw 'Expected comment to include comment markers.' }
                    if (-not $Lines[0].StartsWith('<#')) { Throw 'Expected comment to start with "<#".' }
                    $Start = 0
                    if ($Lines[0].Count -eq 2) { $Start++ }
                    else { $Lines[0] = $Lines[0].SubString(2) }
                    if (-not $Lines[-1].EndsWith('#>')) { Throw 'Expected comment to end with "#>".' }
                    $End = $Lines.Count - 1
                    if ($Lines[0].Count -eq 2) { $End-- }
                    else { $Lines[-1] = $Lines[-1].SubString(0, $Lines[-1].Length - 2) }
                    $Help = GetHelpItems ($Lines[$Start..$End])
                    if ($Help.Contains('Synopsis')) { return $Help }
                    $Comments.Clear()
                }
            }
            elseif (-not $Token -or $Token.Type -ne 'NewLine') {
                if ($Comments.Count -gt 2) {
                    $Help = GetHelpItems $Comments
                    if ($Help.Contains('Synopsis')) { return $Help }
                }
                $Comments.Clear()
            }
        } while ($Token)
    }

    function SplitInLineCode ([String]$Markdown) {
        $Left = ''
        While ($Markdown -Match '^([^`]*)(`+)([\s\S]*)$') {
            $Code, $Right = $Matches[3] -Split "(?<!``)$($Matches[2])(?!``)", 2
            if ($Null -ne $Right) {
                $Left + $Matches[1]
                $Matches[2] + $Code + $Matches[2]
                $Markdown = $Right
                $Left = ''
            }
            else {
                $Left += $Matches[1] + $Matches[2]
                $Markdown = $Matches[3]
            }
        }
        $Left + $MarkDown
    }

    function QuickLinks($Markdown) {
        $CallBack = {
            $Label = $Args[0].Value.TrimStart('[').TrimEnd(']')
            if ($Label -match '^example\s*(\d+)' -and $Help.Example.Contains([int]$Matches[1])) {
                "[$Label](#example-$($Matches[1]))"
            }
            elseif ( $Label -Match '^(-\w+)(\s+parameter)?$' -and $Help.Parameter.Contains($Matches[1].TrimStart('-')) ) {
                "[``$($Matches[1])``$($Matches[2])](#$($Matches[1].ToLower()))"
            }
            else {
                $Command = Get-Command $Label -ErrorAction SilentlyContinue
                if ($Command.HelpUri) { "[``$Label``]($($Command.HelpUri))" }
                else { "[$Label](#$(($Label -Replace '\W+', '-').Trim('-').ToLower()))" }
            }
        }
        $Index = 0
        -Join @(
            foreach ($String in @(SplitInLineCode $Markdown)) {
                if ($Index++ -band 1) { $String } # Inline code
                else { ([regex]'(?<!\])\[[^\[\]\n]+\](?![\[\(])').Replace($String, $CallBack) }
            }
        )
    }

    function GetMarkDown([Sentence[]]$Sentences) {
        $CodeOffset = $TextOffset = 99
        foreach ($Sentence in $Sentences) { # determine general offset
            if ($Sentence.Text -and $Sentence.Offset -lt $TextOffset) { $TextOffset = $Sentence.Offset }
        }
        if ($Null -eq $Script:Indent) { $Script:Indent = $TextOffset }
        elseif ($TextOffset -gt $Script:Indent) { $TextOffset = $Script:Indent }

        foreach ($Sentence in $Sentences) { # determine code offset
            if ($Sentence.Text -and $Sentence.Offset -ge $TextOffset + $TabSize) {
                if ($Sentence.Offset -lt $CodeOffset) { $CodeOffset = $Sentence.Offset }
            }
        }

        $SkipLines = 0
        [MDBlock]$MDBlock = 'None'

        foreach ($Sentence in $Sentences) {
            if ($MDBlock -eq 'Fenced') {
                $Sentence.Indent(-$TextOffset)
                if ($Sentence.Text -Match $Fence ) {
                    $SkipLines = 1
                    $MDBlock = 'None'
                }
            }
            elseif ($Sentence.Text -Match '^`{3,4}') { # Either: ``` or: ````
                if ($SkipLines) { '' }
                $Sentence.Indent(-$TextOffset)
                $SkipLines = 0
                $MDBlock = 'Fenced'
                $Fence = $Matches[0]
            }
            elseif (!$Sentence.Text) { $SkipLines++ }
            elseif ($Sentence.Offset -lt $TextOffset + $TabSize) { # Text block
                if ($MDBlock -eq 'Text') {
                    if ($SkipLines) { '' }
                }
                elseif ($MDBlock -eq 'Code') {
                    '```'
                    ''
                }
                QuickLinks ($Sentence.Text -Replace $AlternateEOL, '  ')
                $SkipLines = 0
                $MDBlock = 'Text'
            }
            else { # if ($Sentence.Offset -ge $TextOffset + $TabSize) { # Code block
                if ($MDBlock -eq 'Code') {
                    if ($SkipLines) { @('') * $SkipLines }
                }
                elseif ($MDBlock -eq 'Text') {
                    ''
                    '```PowerShell'
                }
                $Sentence.Indent(-$TextOffset - $TabSize)
                $SkipLines = 0
                $MDBlock = 'Code'
            }
        }
        if ('Code', 'Fenced' -eq $MDBlock) { '```' }
    }

    function GetTypeLink($TypeName) {
        $Type = $TypeName -as [Type]
        if ($Type) {
            $TypeUri = 'https://docs.microsoft.com/en-us/dotnet/api/' + $Type.FullName
            "<a href=""$TypeUri"">&lt;$($Type.Name)&gt;</a>"
        }
        else {
            $TypeName
        }
    }

    function ToExpression($Object) {
        if ($null -eq $Object) { return '$Null' }
        $Object.foreach{
            if ($null -eq $_) { '$Null' }
            elseif ($Object -is [Bool])      { "`$$_" }
            elseif ($Object -is [ValueType]) { $_ }
            elseif ($Object -is [String])    { "'$_'" }
            else                             { $_ }

        } -Join ', '
    }
}

process {
    if ($PSBoundParameters.ContainsKey('ScriptBlock')) {
        $Ast = [Parser]::ParseInput($ScriptBlock, [ref]$Null, [ref]$Null)
        if (-not $Ast) { StopError "Cannot parse script." }
    }
    else {
        $File = try { Get-Item $Path } catch { $Null }
        if (-not $File) { StopError "Cannot find file '$Path'." }
        $Ast = [Parser]::ParseFile($File.FullName, [ref]$Null, [ref]$Null)
        if (-not $Ast) { StopError "Cannot parse file '$Path'." }
    }
    $Body =
        if ($Command) { $Ast.EndBlock.Statements.where{$_.Name -eq $Command}.Body }
        elseif ($Ast.ParamBlock) { $Ast }
        else {
            $Function = $Ast.EndBlock.Statements.where{ $_ -is [FunctionDefinitionAst] }
            if ($Function.Count -eq 1) { $Function.Body }
            else { $Ast.EndBlock.Statements.where{ $_.name -is $File.BaseName }.Body }
        }
    if (-not $Body) { StopError "Cannot find any parameters." }
    $Help = GetCommentedHelp $Body
    if (-not $Help -and $Body.Parent) { $Help = GetCommentedHelp $Ast }
    if (-not $Help) { StopError "Cannot find comment base help in '$Source'" }

    $Parameters = $Body.ParamBlock.Parameters
    $ParameterSets = [Ordered]@{}
    $AllSets = [List[String]]::new()
    $Parameters.foreach{
        $Name =  $_.Name.VariablePath.UserPath
        $Sets = $_.Attributes.NamedArguments.where{ $_.ArgumentName -eq 'ParameterSetName' }
        if ($Sets) {
            foreach ($SetName in $Sets.Argument.Value) {
                if (-not $ParameterSets.Contains($SetName)) { $ParameterSets[$SetName] = [Ordered]@{} }
                $ParameterSets[$SetName][$Name] = $_
            }
        }
        else { $AllSets.Add($Name) }
    }
    $Parameters.where{$_.Name.VariablePath.UserPath -in $AllSets}.foreach{
        $Name = $_.Name.VariablePath.UserPath
        if ($Name -in $AllSets) {
            foreach ($SetName in $ParameterSets.get_Keys()) { $ParameterSets[$SetName][$Name] = $_ }
        }
    }
    foreach ($SetName in $ParameterSets.get_Keys()) {
        $ParameterSets[$SetName]['<CommonParameters>'] = $Null
        if ($Ast.DynamicParamBlock) { $ParameterSets[$SetName]['<DynamicParameters>'] = $Null }
    }

# Start exporting markdown

    '<!-- markdownlint-disable MD033 -->'

    $Name = if ($Body.Parent.Name) { $Body.Parent.Name } else { $File.BaseName }
    "# $Name"
    ''
    GetMarkDown $Help.Synopsis

    if ($ParameterSets.get_Count()) {
        ''
        '## Syntax'

        foreach ($ParameterSet in $ParameterSets.Values) {
            ''
            '```PowerShell'
            $Name
            foreach ($Key in $ParameterSet.get_Keys()) {
                $Parameter = $ParameterSet[$Key]
                $Type, $Default, $Positional, $Optional = $Null
                if ($ParameterSet[$Key] -is [ParameterAst]) {
                    $Key       = "-$Key"
                    $Type       = $Parameter.StaticType.Name
                    $Default    = $Parameter.DefaultValue
                    $Positional = $Parameter.Attributes.Position -lt 0
                    $Optional   = !$Parameter.Attributes.NamedArguments.where{ $_.ArgumentName -eq 'Mandatory' }
                }
                if (!$Positional -and !$Optional) { $Key = "[$Key]" }
                if ($Type -and $Type -ne 'SwitchParameter') { $Key += " <$Type>" }
                if ($Default) { $Key += " = $Default" }
                if ($Optional) { $Key = "[$Key]" }
                $Tab + $Key
            }
            '```'
        }
    }

    if ($Help.Contains('Description')) {
        ''
        '## Description'
        ''
        GetMarkDown $Help.Description
    }

    if ($Help.Contains('Example')) {
        ''
        '## Examples'

        $Count = $Help.Example.Count
        for ($i = 1; $i -le $Count; $i++) {
            $Id = "example-$i"
            $MarkDown = GetMarkDown $Help.Example[$i]
            if ($Help.Example[$i].Count -and $Help.Example[$i][0].Text.StartsWith('#')) {
                $Caption = $Help.Example[$i][0].Text.SubString(1).Trim()
                $Anchor = ('example-' + $Caption -Replace '\W+', '-').Trim('-').ToLower()
                ''
                "### <a id=""$Id""><a id=""$Anchor"">Example $($i): $Caption</a></a>"
                ''
                GetMarkDown $Help.Example[$i] | Select-Object -Skip 1
                $Help.Example[$('example-' + $Caption -Replace '\W+', '-').Trim('-')] = $Id
            }
            else {
                "### <a id=""$Id"">Example $($i):</a>"
                ''
                GetMarkDown $Help.Example[$i]
                ''
            }
        }
    }

    if ($Parameters) {
        ''
        '## Parameters'
        $Parameters.foreach{
            $Name = $_.Name.VariablePath.UserPath
            $Type = if ($_.StaticType.Name -ne 'SwitchParameter') { $_.StaticType.Name -as [Type] }
            $TypeLink = if ($Type) {
                $TypeUri = 'https://docs.microsoft.com/en-us/dotnet/api/' + $Type.FullName
                " <a href=""$TypeUri"">&lt;$($Type.Name)&gt;</a>"
            }

            ''
            "### <a id=""-$($Name.ToLower())"">``-$Name``$TypeLink</a>"
            if ($Help.Contains('Parameter') -and $Help.Parameter.Contains($Name)) {
                ""
                GetMarkDown $Help.Parameter[$Name]
            }
            ''
            $Dictionary = [Ordered]@{}
            $Attributes = $_.Attributes
            if ($Null -ne $Attributes.MinLength -and $Null -ne $Attributes.MaxLength) { $Dictionary['Accepted length']           = $Attributes.MinLength - $Attributes.MaxLength }
            elseif ($Null -ne $Attributes.MinLength)                                  { $Dictionary['Minimal length']            = $Attributes.MinLength }
            elseif ($Null -ne $Attributes.MaxLength)                                  { $Dictionary['Maximal length']            = $Attributes.MaxLength }
            if ($Null -ne $Attributes.RegexPattern)                                   { $Dictionary['Accepted pattern']          = "<code>$($Attributes.RegexPattern)</code>" }
            if ($Null -ne $Attributes.MinRange -and $Null -ne $Attributes.MaxRange)   { $Dictionary['Accepted range']            =  $Attributes.MinRange - $Attributes.MaxRange }
            elseif ($Null -ne $Attributes.MinRange)                                   { $Dictionary['Minimal value']             =  $Attributes.MinRange }
            elseif ($Null -ne $Attributes.MaxRange)                                   { $Dictionary['Maximal value']             =  $Attributes.MaxRange }
            if ($Null -ne $Attributes.ScriptBlock)                                    { $Dictionary['Accepted script condition'] =  "<code>$($Attributes.ScriptBlock.ToString().Trim() -Split '\s*[\r?\n]\s*' -Join '; ')</code>" }
            if ($Null -ne $Attributes.ValidValues)                                    { $Dictionary['Accepted values']           =  $Attributes.ValidValues -Join ', ' }
            $Dictionary['Name']             = "-$Name"
            $Aliases = $_[0].Attributes.where{ $_.TypeName.Name -eq 'Alias' }.PositionalArguments.foreach{ "-$($_.Value)" } -Join ', '
            $Dictionary['Aliases']          = if ($Aliases) { $Aliases } else { '# None' }
            $Dictionary['Type']             = "[$($_.StaticType.Name)]"
            $Dictionary['Value (default)']  = if ($_.DefaultValue) { ToExpression $_.DefaultValue } else { '# Undefined' }
            $ParameterSetNames = $_.Attributes.NamedArguments.where{ $_.ArgumentName -eq 'ParameterSetName' }.Argument.Value
            $Dictionary['Parameter sets']   = if ($ParameterSetNames) { $ParameterSetNames -Join ', ' } else { '# All' }
            $Dictionary['Mandatory']        = [bool]$Attributes.NamedArguments.where{ $_.ArgumentName -eq 'Mandatory' }
            $Dictionary['Position']         =
                if ($Attributes.Position -lt 0) { '# Named' }
                elseif ($Attributes.Position -ne $Attributes.Position[0]) { $Attributes.Position -Join ', ' }
                else { $Attributes.Position[0] }
            $Dictionary['Accept pipeline input']      = [Bool]$Attributes.ValueFromPipelineByPropertyName
            $Dictionary['Accept wildcard characters'] = ($_.Attributes.where{$_.TypeName.Name -eq 'SupportsWildcards'}).Count -gt 0

            '```powershell'
            $Dictionary.get_Keys().ForEach{ -Join ("$($_):".PadRight(28), $Dictionary[$_]) }
            '```'

        }
    }

    if ($Help.Contains('Inputs')) {
        ''
        '## Inputs'
        ''
        GetMarkDown $Help.Inputs
    }

    if ($Help.Contains('Outputs')) {
        ''
        '## Outputs'
        ''
        GetMarkDown $Help.Outputs
    }

    if ($Help.Contains('Link')) {
        ''
        '## Related Links'
        ''
        $LinkReferences = [List[String]]::new()
        $InList = $null
        ForEach ($Sentence in $Help.Link) {
            $IsLink = $Sentence.Text -Match $ReferencePattern
            if ($IsLink) {
                if ($Matches.Contains('Label')) { $LinkReferences.Add($Matches[0]) }
                if ($Matches.Contains('Title') -and $Matches['Title']) {
                    "* [$($Matches['Title'])]($($Matches['Uri']))"
                }
                elseif ($Matches.Contains('Uri')) { "* $($Matches['Uri'])" }
            }
            else {
                if ($InList) { '<!-- -->' }
                $Sentence.Text
            }
            $InList = $IsLink
        }
        if ($LinkReferences) {
            ''
            @($LinkReferences).ForEach{ $_ }
        }
    }
    ''
    '[comment]: <> (Created with Get-MarkdownHelp: Install-Script -Name Get-MarkdownHelp)'
}