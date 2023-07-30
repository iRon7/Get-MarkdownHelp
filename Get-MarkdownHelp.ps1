<#PSScriptInfo
.VERSION 1.1.1
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
    Creates a markdown Readme string from the comment based help of a command

.DESCRIPTION
    The [Get-MarkdownHelp][1] cmdlet retrieves the [comment-based help][2] and converts it to a Markdown page
    similar to the general online PowerShell help pages (as e.g. [Get-Content]).\
    Note that this cmdlet *doesn't* support `XML`-based help files, but has a few extra features for the comment-based
    help as opposed to the native [platyPS][3] [New-MarkdownHelp]:

    * **Code Blocks**

    To create code blocks, indent every line of the block by at least four spaces or one tab relative the **text indent**.
    The **text indent** is defined by the smallest indent of the current - and the `.SYNOPSIS` section.\
    Code blocks are automatically [fenced][4] for default PowerShell color coding.\
    The usual comment-based help prefix for code (`PS. \>`) might also be used to define a code lines.
    For more details, see the [-PSCodePattern parameter].

    As defined by the standard help interpreter, code blocks (including fenced code blocks) can't include help keywords.
    Meaning (fenced) code blocks will end at the next section defined by `.<help keyword>`.

    * **Titled Examples**

    Examples can be titled by adding an (extra) hash (`#`) in front of the first line in the section.
    This line will be removed from the section and added to the header of the example.

    * **Links**

    > As Per markdown definition, The first part of a [reference-style link][5] is formatted with two sets of brackets.
    > The first set of brackets surrounds the text that should appear linked. The second set of brackets displays
    > a label used to point to the link you're storing elsewhere in your document, e.g.: `[rabbit-hole][1]`.
    > The second part of a reference-style link is formatted with the following attributes:

    > * The label, in brackets, followed immediately by a colon and at least one space (e.g., `[label]:` ).
    > * The URL for the link, which you can optionally enclose in angle brackets.
    > * The optional title for the link, which you can enclose in double quotes, single quotes, or parentheses.

    For the comment-base help implementation, the second part should be placed in the `.LINK` section to automatically
    listed in the end of the document. The reference will be hidden if the label is an explicit empty string(`""`).

    * **Quick Links**

    Any phrase existing of a combination alphanumeric characters, spaces, underscores and dashes between squared brackets
    (e.g. `[my link]`) will be linked to the (automatic) anchor id in the document, e.g.: `[my link](#my-link)`.

    > **Note:** There is no confirmation if the internal anchor really exists.

    * **Parameter Links**

    **Parameter links** are similar to **Quick Links** but start with a dash and contain an existing parameter name possibly
    followed by the word "parameter". E.g.: `[-AlternateEOL]` or `[-AlternateEOL parameter]`.
    In this example, the parameter link will refer to the internal [-AlternateEOL parameter].

    * **Cmdlet Links**

    **Cmdlet links** are similar to **Quick Links** but contain a cmdlet name where the online help is known. E.g.: `[Get-Content]`.
    In this example, the cmdlet link will refer to the online help of the related [Get-Content] cmdlet.

.INPUTS
    A (reference to a) command or module

.OUTPUTS
    `String[]`

.PARAMETER Source
    The source of the commented help.
    This might a command or module by it name or file location.

.PARAMETER Command
    An embedded command that contains the parameters or actual commented help.

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

        .\Get-MarkdownHelp.ps1 .\Show-MarkDown.ps1 |Out-String |Show-Markdown -UseBrowser

.EXAMPLE
    # Copy markdown help to a website
    This command creates a markdown readme string for the `Join-Object` cmdlet and puts it on the clipboard
    so that it might be pasted into e.g. a GitHub readme file.

        Get-MarkdownHelp Join-Object |Clip

.EXAMPLE
    # Save markdown help to file
    This command creates a markdown readme string for the `.\MyScript.ps1` script and saves it in `Readme.md`.

        Get-MarkdownHelp .\MyScript.ps1 |Set-Content .\Readme.md

.LINK
    [1]: https://github.com/iRon7/Get-MarkdownHelp "Online Help"
    [2]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help "About comment based help"
    [3]: https://github.com/PowerShell/platyPS "PlatyPS MALM renderer"
    [4]: https://www.markdownguide.org/extended-syntax/#fenced-code-blocks "Fenced Code Blocks"
    [5]: https://www.markdownguide.org/basic-syntax/#reference-style-links "Reference-style Links"
    [7]: https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidtrailingwhitespace ""

    https://www.markdownguide.org/basic-syntax/ "Markdown guide"
#>

using NameSpace System.Management.Automation
using NameSpace System.Management.Automation.Language

[CmdletBinding()][OutputType([String[]])] param(
    [Parameter(ValueFromPipeLine = $True, ValueFromPipelineByPropertyName = $True)]
    $Source,

    [Parameter(ValueFromPipelineByPropertyName = $True)]
    $Command,

    [String]$PSCodePattern = 'PS.*\>',

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

    function GetContent ($Source) {

            if ($Source -is [AliasInfo]) { $Source = $Source.ResolvedCommand }

            if ($Source -is [Ast])          { $Source.Extent.Text }
        elseif ($Source -is [ScriptBlock])  { $Source }
        elseif ($Source -is [CommandInfo])  { $Source.ScriptBlock }
        elseif ($Source -is [PSModuleInfo]) { Get-Content -Raw -LiteralPath $Source.Path }
        elseif ($Source -is [String])       { Get-Content -Raw -LiteralPath $Source }
        else   { Throw "Unknown source type: $($Source.PSTypeNames)" }
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
                { $_.StartsWith('<#') } {}
                { $_.EndsWith('#>')   } {}
                { '.Synopsis', '.Description', '.Inputs', '.Outputs', '.Notes', '.Link' -eq $_ } {
                    $Key = $_.SubString(1)
                    $Item = $Help[$Key] = [Collections.Generic.List[Sentence]]::new()
                }
                '.Example' {
                    if (!$Help.Contains('Example')) { $Help['Example'] = [Collections.Generic.List[object]]::new() }
                    $Help['Example'].Add([Collections.Generic.List[Sentence]]::new())
                    $Item = $Help['Example'][-1]
                }
                { $_ -Like '.Parameter *' } {
                    if (!$Help.Contains('Parameter')) { $Help['Parameter'] = @{} }
                    $Name = ($_ -Split '\.Parameter\s+', 2)[1]
                    $Item = $Help['Parameter'][$Name] = [Collections.Generic.List[Sentence]]::new()
                }
                Default {
                    if ($Null -ne $Item) { if ($Item.Count -Or $Sentence.Text) { $Item.add($Sentence) } }
                    elseif (!$_) { break }
                }
            }


        }
        $Help
    }

    function GetHelp([String]$Content) {
        $Help = $Null
        $Lines = [Collections.Generic.List[String]]::new()
        foreach ($Token in [PSParser]::Tokenize($Content, [Ref]$Null)) {
            if ($Token.Type -eq 'Comment') {
                if ($Token.Content.StartsWith('#') ) {
                    $Lines.Add($Token.Content.SubString(1))
                }
                else { #Block Comment
                    $Help = GetHelpItems ($Token.Content -split '\r?\n')
                    $Lines.Clear()
                }

            }
            elseif ($Token.Type -ne 'NewLine') {
                $Help = GetHelpItems $Lines
                $Lines.Clear()
            }
            if ($Help -and $Help.Count -and $Help.Contains('Synopsis')) { return $Help }
        }
        if ($Lines.Count -and !$Help) { GetHelpItems $Lines } # Only line commented help
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
            if ( $Label -Match '^(-\w+)(\s+parameter)?$' -and $ParamNames -eq $Matches[1].TrimStart('-') ) {
                "[``$($Matches[1])``$($Matches[2])](#$($Matches[1].ToLower()))"
            }
            else {
                $Command = Get-Command $Label -ErrorAction SilentlyContinue
                if ($Command.HelpUri) { "[``$Label``]($($Command.HelpUri))" }
                else { "[$Label](#$($Label.ToLower() -Replace '\W+', '-'))" }
            }
        }
        $Index = 0
        -Join @(
            foreach ($String in @(SplitInLineCode $Markdown)) {
                if ($Index++ -band 1) { $String } # Inline code
                else { ([regex]'(?<!\])\[[\w\- ]+\](?![\[\(])').Replace($String, $CallBack) }
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
            $TypeName = $Type.Name
            $TypeUri = 'https://docs.microsoft.com/en-us/dotnet/api/' + $Type.FullName
            "<a href=""$TypeUri"">$TypeName</a>"
        }
        else {
            $TypeName
        }
    }

    function GetInfo($Command) {
        if ($Command -is [String] -and !$Command.Contains("`n"))  {
            if ($Test = Get-Command $Command -ErrorAction SilentlyContinue) { $Command = $Test }
        }
        if ($Command -is [ApplicationInfo] -and ($Test = Import-Module $Command.Source -PassThru)) { $Command = $Test }
        if ($Command -and ($Test = Get-Module  $Command -ErrorAction SilentlyContinue)) { $Command = $Test }
        if ($Command -is [AliasInfo]) { $Command = $Command.ResolvedCommand }
        if ($Command -is [String] -and ($Test = New-Item -Path function:\ -Name 'Unknown' -Value $Command.ScriptBlock -Force -ErrorAction SilentlyContinue)) { $Command = $Test }
        $Command
    }

}

process {

    # https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.commandtypes

    # CommandType       Example
    # -----------       -------
    # Alias             Get-Command GCI
    # All
    # Application       Get-Command .\Test.psm1
    # Cmdlet            Get-Command Write-Host
    # Configuration
    # ExternalScript    Get-Command .\Test.ps1
    # Filter
    # Function          New-Item -Path function: -Name $Name -Value $Value
    # Script            Get-Module PSReadLine


    $Source  = GetInfo $Source
    $Command = GetInfo $Command

    if (!$Source -and $Command) {   # $Source is the actual command container (if exists)
        $Source = $Command
        $Command = $Null
    }

    if ($Source -is [CommandInfo] -and $Source.ModuleName -and !$Command) {
        $Command = Import-Module $Source.ModuleName -PassThru
    }
    elseif ($Command -is [CommandInfo] -and $Command.ModuleName -and !$Command) {
        $Source = Import-Module $Contact.ModuleName -PassThru
    }

    if ($Source -and $Command) {
        if ($Source -is [String] -and $Command -is [CommandInfo]) {
            . $Command
            $Source  = GetInfo $Source
        }
        elseif ($Command -is [String] -and $Source -is [CommandInfo]) {
            . $Command
            $Source  = GetInfo $Source
        }
    }

    if ($Source -isnot [PSModuleInfo] -and $Command -is [PSModuleInfo]) {
        $Source, $Command = $Command, $Source
        if ($Command -is [String] -and $Source.ExportedFunctions -eq $Command) { $Command = Get-Command $Command }
    }

    if ($Source -is [PSModuleInfo]) {
         $ExportedName = $Source.ExportedCommands.Keys
         if ($Command) {
            if (-not ($ExportedName -eq $Command)) { StopError "Source command '$Command' doesn't exist" }
            $Command = $Command, $Source
        }
        else {
            $Exported = $Source.ExportedCommands.Values.Where{ $_ -is [CommandInfo] }
            if (!$Exported) { StopError "No exported commands found for $Source" }
            if ($Exported.Count -eq 1) { $Command = $Exported, $Source }
            elseif ($ExportedName -eq $Source.Name) { $Command = $Source.ExportedCommands[$Source.Name], $Source }
            else {
                Write-Warning "Multiple exported commands found for $Source"
                $Command = $Source, $Exported[0]
            }
        }
    }
    elseif ($Command -is [CommandInfo]) { $Command = $Command, $Source }
    elseif ($Command) { StopError "Can't find command '$Command'" }
    else { $Command = $Source } # $Source -isnot [PSModuleInfo]

    $Help = $Null
    foreach ($Item in @($Command)) {
        $Content = GetContent $Item
        $Help = GetHelp $Content
        if ($Help) { break }
    }
    if (!$Help) { StopError "Can't find comment base help in: $Command" }

#    Write-Debug "Help: [$($Help.PSTypeNames[0])]$Command"

    $Ast = $Null
    foreach ($Item in @($Command)) {
        $Content = GetContent $Item
        $Ast = [Parser]::ParseInput($Content, [ref]$Null, [ref]$Null)
        if ($Ast.ParamBlock) { break }
    }
    if ($ScriptBlockAst) { StopError "Can't find parameter block in: $Command" }

    $Parameters = $Ast.ParamBlock.Parameters
    $CommonParams = [PSCmdlet]::CommonParameters + [PSCmdlet]::OptionalCommonParameters
    $ParameterSets = [Ordered]@{}
    $Parameters.foreach{
        $Name =  $_.Name.VariablePath.UserPath
        $Sets = $_.Attributes.NamedArguments.where{ $_.ArgumentName -eq 'ParameterSetName' }
        foreach ($Value in @($Sets.Argument.Value)) {
            $SetName = if ($Value) { "$Value" } else { '__AllParameterSets' }
             if (!$ParameterSets.Contains($SetName)) { $ParameterSets[$SetName] = [Ordered]@{} }
            $ParameterSets[$SetName][$Name] = $_ 
        }
    }
    foreach ($SetName in $ParameterSets.get_Keys()) {
        $ParameterSets[$SetName]['<CommonParameters>'] = $Null
        if ($Ast.DynamicParamBlock) { $ParameterSets[$SetName]['<DynamicParameters>'] = $Null }
    }

# Start exporting markdown

    '<!-- markdownlint-disable MD033 -->'

    $Name = if ($Command.Name) { @($Command.Name)[0] } else { 'Unknown' }
    "# $Name"
    ''
    GetMarkDown $Help.Synopsis

    if ($ParameterSets.get_Count()) {
        ''
        '## Syntax'
        
        foreach ($ParameterSet in $ParameterSets.Values) {
            ''
            '```JavaScript'
            foreach ($Name in $ParameterSet.get_Keys()) {
                $Parameter = $ParameterSet[$Name]
                $Type, $Default, $Positional, $Optional = $Null
                if ($ParameterSet[$Name] -is [ParameterAst]) {
                    $Name       = "-$Name"
                    $Type       = $Parameter.StaticType.Name
                    $Default    = $Parameter.DefaultValue
                    $Positional = $Parameter.Attributes.Position -lt 0
                    $Optional   = !$Parameter.Attributes.NamedArguments.where{ $_.ArgumentName -eq 'Mandatory' }
                }
                if (!$Positional -and !$Optional) { $Name = "[$Name]" }
                if ($Type -and $Type -ne 'SwitchParameter') { $Name += " <$Type>" }
                if ($Default) { $Name += " = $Default" }
                if ($Optional) { $Name = "[$Name]" }
                $Tab + $Name
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

        for ($i = 0; $i -lt $Help.Example.Count; $i++) {
            $Count = $Help.Example[$i].Count
            if ($Count -gt 1 -and $Help.Example[$i][0].Text.StartsWith('#')) {
                ''
                "### Example $($i + 1): " + $Help.Example[$i][0].Text.SubString(1).Trim()
                ''
                GetMarkDown $Help.Example[$i][1..($Count - 1)]
            }
            else {
                "### Example $($i + 1):"
                ''
                GetMarkDown $Help.Example[$i]
                ''
            }
        }
    }

    if ($Parameters) {
        ''
        '## Parameter'
        $Parameters.foreach{
            $Name =  $_.Name.VariablePath.UserPath
            $Type = $_.parameterType.Name
            $_Type = if ($Type -ne 'SwitchParameter') { " <$Type>" }
            ''
            "### <a id=""-$($Name.ToLower())"">**``-$Name$_Type``**</a>"
            if ($Help.Contains('Parameter') -and $Help.Parameter.Contains($Name)) {
                ""
                GetMarkDown $Help.Parameter[$Name]
            }
            ''
            $Dictionary = [Ordered]@{}
            $Attributes = $_.Attributes
            if ($Null -ne $Attributes.MinLength -and $Null -ne $Attributes.MaxLength) { $Dictionary['Accepted length']           = $Attributes.MinLength - $Attributes.MaxLength }
            elseif ($Null -ne $Attributes.MinLength)                                  { $Dictionary['Minimal length']            = $Attributes.MinLemgth }
            elseif ($Null -ne $Attributes.MaxLength)                                  { $Dictionary['Maximal lemgth']            = $Attributes.MaxLength }
            if ($Null -ne $Attributes.RegexPattern)                                   { $Dictionary['Accepted pattern']          = "<code>$($Attributes.RegexPattern)</code>" }
            if ($Null -ne $Attributes.MinRange -and $Null -ne $Attributes.MaxRange)   { $Dictionary['Accepted range']            =  $Attributes.MinRange - $Attributes.MaxRange }
            elseif ($Null -ne $Attributes.MinRange)                                   { $Dictionary['Minimal value']             =  $Attributes.MinRange }
            elseif ($Null -ne $Attributes.MaxRange)                                   { $Dictionary['Maximal value']             =  $Attributes.MaxRange }
            if ($Null -ne $Attributes.ScriptBlock)                                    { $Dictionary['Accepted script condition'] =  "<code>$($Attributes.ScriptBlock.ToString().Trim() -Split '\s*[\r?\n]\s*' -Join '; ')</code>" }
            if ($Null -ne $Attributes.ValidValues)                                    { $Dictionary['Accepted values']           =  $Attributes.ValidValues -Join ', ' }
            $Dictionary['Type'] = GetTypeLink($_.parameterType)
            $Dictionary['Mandatory'] = [bool]$Attributes.NamedArguments.where{ $_.ArgumentName -eq 'Mandatory' }
            if ($_.Aliases) { $Dictionary['Aliases'] = $_.Aliases -Join ', ' }
            $Position = if ($Attributes.Position -ge 0) {$Attributes.Position } else { 'Named' }
            $Position = if ($Attributes.Position -lt 0) { 'Named' }
                        elseif ($Attributes.Position -ne $Attributes.Position[0]) { $Attributes.Position -Join ', ' }
                        else { $Attributes.Position[0] }
            $Dictionary['Position']                   = $Position
            $DefaultValue                             = if ($_.DefaultValue) { "<code>$($_.DefaultValue)</code>" } # https://stackoverflow.com/a/64358608/1701026
            $Dictionary['Default value']              = $DefaultValue
            $Dictionary['Accept pipeline input']      = $Attributes.ValueFromPipelineByPropertyName
            $Globbing = ($_.Attributes.where{$_.TypeName.Name -eq 'SupportsWildcards'}).Count -gt 0
            $Dictionary['Accept wildcard characters'] = $Globbing
            '<table>'
            $Dictionary.get_Keys().ForEach{ "<tr><td>$($_):</td><td>$($Dictionary[$_])</td></tr>"}
            '</table>'
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
        $LinkRefences = [Collections.Generic.List[String]]::new()
        ForEach ($Sentence in $Help.Link) {
            $Text = $Sentence.Text
            $Link = if ($Text -Match $ReferencePattern) {
                if ($Matches.Contains('Label')) {
                    $LinkRefences.Add($Text)
                    if ($Matches.Contains('Title')) {
                        if ($Matches['Title']) { "$($Matches['Label']): [$($Matches['Title'])][$($Matches['Label'])]" }
                    }
                    else {
                        "$($Matches['Label']): $($Matches['Uri'])"
                    }
                }
                elseif ($Matches.Contains('Title')) {
                    "[$($Matches['Title'])]($($Matches['Uri']))"
                }
                else { $Matches['Uri'] }
            }
            if ($Link) { "* $Link" }
        }
        if ($LinkRefences) {
            ''
            @($LinkRefences).ForEach{ $_ }
        }
    }
}
