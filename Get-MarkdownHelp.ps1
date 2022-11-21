<#PSScriptInfo
.VERSION 1.0.0
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

    * **Code Blocks**\
    To create code blocks, indent every line of the block by at least four spaces or one tab relative the **text indent**.
    The **text indent** is defined by the smallest indent of the current - and the `.SYNOPSIS` section.\
    Code blocks are automatically [fenced][4] for default PowerShell color coding.\
    The usual comment-based help prefix for code (`PS. \>`) might also be used to define a code lines.
    For more details, see the [-PSCodePattern parameter].

    * **Titled Examples**\
    Examples can be titled by adding an (extra) hash (`#`) in front of the first line in the section.
    This line will be removed from the section and added to the header of the example.

    * **Links**\
    > As Per markdown definititon, The first part of a [reference-style link][5] is formatted with two sets of brackets.
    > The first set of brackets surrounds the text that should appear linked. The second set of brackets displays
    > a label used to point to the link you’re storing elsewhere in your document, e.g.: `[rabbit-hole][1]`.
    > The second part of a reference-style link is formatted with the following attributes:
    > * The label, in brackets, followed immediately by a colon and at least one space (e.g., `[label]:` ).
    > * The URL for the link, which you can optionally enclose in angle brackets.
    > * The optional title for the link, which you can enclose in double quotes, single quotes, or parentheses.

    For the comment-base help implementation, the second part should be placed in the `.LINK` section to automatically
    listed in the end of the document. The reference will be hidden if the label is an explicit empty string(`""`).

    * **Quick Links**\
    Any phrase existing of a combination alphanumeric characters, spaces, underscores and dashes between squared brackets
    (e.g. `[my link]`) will be linked to the (automatic) anchor id in the document, e.g.: `[my link](#my-link)`.

    > **Note:** There is no confirmation if the internal anchor really exists.

    * **Parameter Links**\
    **Parameter links** are similar to **Quick Links** but start with a dash and contain an existing parameter name possibly
    followed by the word "parameter". E.g.: `[-AlternateEOL]` or `[-AlternateEOL parameter]`.
    In this example, the parameter link will refer to the internal [-AlternateEOL parameter].

    * **Cmdlet Links**\
    **Cmdlet links** are simular to **Quick Links** but contain a cmdlet name where the online help is known. E.g.: `[Get-Content]`.
    In this example, the cmdlet link will refer to the online help of the related [Get-Content] cmdlet.

.INPUTS
    String (command name)

.OUTPUTS
    String[]

.PARAMETER CommandName
    Specifies the name of the cmdlet that contains the [comment based help][2].

.PARAMETER PSCodePattern
    Specifies the PowerShell code pattern used by the get-help cmdlet.
    The native [`Get-Help`] cmdlet automatically adds a PowerShell prompt (`PS \>`) to the first line of an example if not yet exist.
    To be consistent with the first line you might manually add a PowerShell prompt to each line of code which will be converted to
    a code block by this `Get-MarkdownHelp` cmdlet.

.PARAMETER AlternateEOL
    The recommended way to force a line break or new line (`<br>`) in markdown is to end a line with two or more spaces but as that
    might cause a _[Avoid Trailing Whitespace][7]_ warning, you might also consider to use an alternate EOL marker.\
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

[CmdletBinding(DefaultParameterSetName='Html')][OutputType([Object[]])] param(
    [Parameter(ValueFromPipeLine = $True, ValueFromPipelineByPropertyName = $True, Mandatory = $True)]
    [Alias('Name')][String]$CommandName,
    [String]$PSCodePattern = 'PS.*\>',
    [String]$AlternateEOL = '\'
)

begin {
    $TabSize = 4
    $Tab = ' ' * $TabSize
    $CodePrefix = "(?<=^\s*)$PSCodePattern"

    $UriLabelPattern  = '\[(?<Label>.+)\]\:'
    $UriPattern       = '\<?(?<Uri>\w+://\S+)\>?'
    $UriTitlePattern  = '("(?<Title>.+)"|''(?<Title>.*)''|\((?<Title>.?)\))'
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


    function GetHelpItems([String[]]$Lines) {
        $Key = $Null
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

    function GetHelp([String]$Script) {
        $Help = $Null
        $Lines = [Collections.Generic.List[String]]::new()
        foreach ($Token in [System.Management.Automation.PSParser]::Tokenize($Script, [Ref]$Null)) {
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
        $Index = 0
        -Join @(
            foreach ($String in @(SplitInLineCode $Markdown)) {
                if ($Index++ -band 1) { $String } # Inline code
                else {
                    $String -Replace '(?<!\])\[[\w\- ]+\](?![\[\(])', {
                        $Label = $_.Value.TrimStart('[').TrimEnd(']')
                        if ( $Label -Match '^(-\w+)(\s+parameter)?$' -and $ParamNames -eq $Matches[1].TrimStart('-') ) {
                            "[``$($Matches[1])``$($Matches[2])](#$($Matches[1]))"
                        }
                        else {
                            $Command = Get-Command $Label -ErrorAction SilentlyContinue
                            if ($Command.HelpUri) { "[``$Label``]($($Command.HelpUri))" }
                            else { "[$Label](#$($Label -Replace '\W+', '-'))" }
                        }
                    }
                }
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

        $Fence = $Null
        $SkipLines = [int]::MinValue

        $Block = $Null
        foreach ($Sentence in $Sentences) {
            if (!$Sentence.Text) { $SkipLines++ }
            elseif ($Block -is [String]) { # Continue fenced code block
                $Sentence.Indent(-$TextOffset)
                if ($Sentence.Text -Match "^$Block" ) { $Block = $Null }
            }
            elseif ($Sentence.Text -Match '^`{3,4}') { # Start fenced code block
                if ($Block -is [System.Text.StringBuilder]) { QuickLinks $Block.ToString() }
                $Block = $Matches[0]
                $Sentence.Indent(-$TextOffset)
            }
            elseif ($Sentence.Offset -ge $TextOffset + $TabSize) { # Start or continue code block
                if ($Block -isnot [int]) { # -eq $CodeOffset
                    if ($Block -is [System.Text.StringBuilder]) { QuickLinks $Block.ToString() }
                    $Block = $CodeOffset
                    '```PowerShell'
                }
                else { @('') * $SkipLines }
                $Sentence.Indent(-$TextOffset - $TabSize)
                $SkipLines = 0
            }
            else { # start or continue text block
                if ($Block -is [int]) { '```' }
                elseif ($Skiplines -ge 1) { $Null = $Block.AppendLine() }
                if ($Block -isnot [System.Text.StringBuilder]) { $Block = [System.Text.StringBuilder]::new() }
                $Text = $Sentence.Text -Replace $AlternateEOL, '  '
                $Null = $Block.AppendLine($Text)
                $SkipLines = 0
            }
        }
        if ($Block -is [System.Text.StringBuilder]) { QuickLinks $Block.ToString() } elseif ($Block -is [Int]) { '```' }
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
}

process {
    $Script:Indent = $Null
    $Command = Get-Command $CommandName
    $Name = [System.IO.Path]::GetFileNameWithoutExtension($Command.Name)
    $Help = $Null

    $Help = GetHelp $Command.ScriptBlock
    if (!$Help -and $Command.Module) {
        $Help = GetHelp (Get-Content -Raw $Command.Module.Path)
    }

    if ($Help) {
        Write-Debug ($Help |ConvertTo-Json -Depth 9)
        
        $Ast = [System.Management.Automation.Language.Parser]::ParseInput($Command.ScriptBlock,[ref]$Null,[ref]$Null)
        $Params = @(if ($Ast.ParamBlock) { $Ast.ParamBlock.FindAll({$Args[0] -is [System.Management.Automation.Language.ParameterAst]}, $True) })
        $ParamNames = @(if ($Params) { $Params.Name.VariablePath.UserPath })

        "# $Name"
        GetMarkDown $Help.Synopsis

        if ($Syntax) {
            '## Syntax'
            '```JavaScript'
            $Syntax = Get-Command $CommandName -Syntax
            foreach ($Line in ($Syntax -split '[\r\n]+')) {
                $SyntaxName, $Parameters = $Line -Split ' (?=\-|\[\-|\[\[|\[\<)'
                if ($SyntaxName -eq $CommandName) {
                    $Name
                    foreach ($Parameter in $Parameters) { $Tab + $Parameter }
                }
            }
            '```'
            ''
        }


        if ($Help.Contains('Description')) {
            '## Description'
            GetMarkDown $Help.Description
        }

        if ($Help.Contains('Example')) {
            '## Examples'
            for ($i = 0; $i -lt $Help.Example.Count; $i++) {
                $Count = $Help.Example[$i].Count
                if ($Count -and $Help.Example[$i][0].Text.StartsWith('#')) {
                    "### Example $($i + 1): " + $Help.Example[$i][0].Text.SubString(1).Trim()
                    if ($Count -gt 0) { GetMarkDown $Help.Example[$i][1..($Count - 1)] }
                }
                else {
                    "### Example $($i + 1):"
                    GetMarkDown $Help.Example[$i]
                }
            }
        }

        if ($Params) {
            '## Parameter'
            foreach ($Param in $Params) {
                $Name = $Param.Name.VariablePath.UserPath
                $Parameter  = $Command.Parameters[$Name]
                $Type = $Parameter.parameterType.Name
                $_Type = if ($Type -ne 'SwitchParameter') { " <$Type>" }
                "#### <a id=""-$($Name.ToLower())"">**``-$Name$_Type``**</a>"
                if ($Help.Contains('Parameter') -and $Help.Parameter.Contains($Name)) { GetMarkDown $Help.Parameter[$Name] } else { '' }
                ''
                $Dictionary = [Ordered]@{}
                $Attributes = $Parameter.Attributes
                if ($Null -ne $Attributes.MinLength -and $Null -ne $Attributes.MaxLength) { $Dictionary['Accepted length']           = $Attributes.MinLength - $Attributes.MaxLength }
                elseif ($Null -ne $Attributes.MinLength)                                  { $Dictionary['Minimal length']            = $Attributes.MinLemgth }
                elseif ($Null -ne $Attributes.MaxLength)                                  { $Dictionary['Maximal lemgth']            = $Attributes.MaxLength }
                if ($Null -ne $Attributes.RegexPattern)                                   { $Dictionary['Accepted pattern']          = "<code>$($Attributes.RegexPattern)</code>" }
                if ($Null -ne $Attributes.MinRange -and $Null -ne $Attributes.MaxRange)   { $Dictionary['Accepted range']            =  $Attributes.MinRange - $Attributes.MaxRange }
                elseif ($Null -ne $Attributes.MinRange)                                   { $Dictionary['Minimal value']             =  $Attributes.MinRange }
                elseif ($Null -ne $Attributes.MaxRange)                                   { $Dictionary['Maximal value']             =  $Attributes.MaxRange }
                if ($Null -ne $Attributes.ScriptBlock)                                    { $Dictionary['Accepted script condition'] =  "<code>$($Attributes.ScriptBlock.ToString().Trim() -Split '\s*[\r?\n]\s*' -Join '; ')</code>" }
                if ($Null -ne $Attributes.ValidValues)                                    { $Dictionary['Accepted values']           =  $Attributes.ValidValues -Join ', ' }
                $Dictionary['Type'] = GetTypeLink($Parameter.parameterType)
                if ($Parameter.Aliases) { $Dictionary['Aliases'] = $Parameter.Aliases -Join ', ' }
                $Position = if ($Attributes.Position -ge 0) {$Attributes.Position } else { 'Named' }
                $Position = if ($Attributes.Position -lt 0) { 'Named' }
                            elseif ($Attributes.Position -ne $Attributes.Position[0]) { $Attributes.Position -Join ', ' }
                            else { $Attributes.Position[0] }
                $Dictionary['Position']                   = $Position
                $DefaultValue                             = if ($Param.DefaultValue) { "<code>$($Param.DefaultValue)</code>" } # https://stackoverflow.com/a/64358608/1701026
                $Dictionary['Default value']              = $DefaultValue
                $Dictionary['Accept pipeline input']      = $Attributes.ValueFromPipelineByPropertyName
                $Globbing = ($Param.Attributes.where{$_.TypeName.Name -eq 'SupportsWildcards'}).Count -gt 0
                $Dictionary['Accept wildcard characters'] = $Globbing
                '<table>'
                $Dictionary.get_Keys().ForEach{ "<tr><td>$($_):</td><td>$($Dictionary[$_])</td></tr>"}
                '</table>'
                ''
            }
        }

        if ($Help.Contains('Inputs')) {
            '## Inputs'
            GetMarkDown $Help.Inputs
        }

        if ($Help.Contains('Outputs')) {
            '## Outputs'
            GetMarkDown $Help.Outputs
        }

        if ($Help.Contains('Link')) {
            '## Related Links'
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
                }
                if ($Link) { "* $Link" }
            }
            if ($LinkRefences) {
                ""
                @($LinkRefences).ForEach{ $_ }
            }
       }
    }
    else { Write-Error "The comment based help for ""$CommandName"" could not be found" }
}
