<#PSScriptInfo
.VERSION 0.9.0
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
This cmdlet uses the command information and Get-Help cmdlet to build a markdown Readme
simular to the general PowerShell online help.

.INPUTS
String (command name)

.OUTPUTS
String[]

.PARAMETER Name
    Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
    You can also pipe objects to ConvertTo-CSV.

.EXAMPLE
    PS> .\Get-MarkdownHelp Show-MarkDown |Out-String |Show-Markdown -UseBrowser

    This command shows a markdown formatted help of the `Show-MarkDown` cmdlet in the default browser.

.EXAMPLE
    PS> Get-MarkdownHelp Get-Content |Clip

    This command will create a markdown readme string for the Get-Content cmdlet and put it on the clipboard
    to be used e.g. pasting it into a GitHub readme file.

.LINK
    https://github.com/iRon7/Get-MarkdownHelp
#>

using namespace System.Management.Automation

[CmdletBinding(DefaultParameterSetName='Html')][OutputType([Object[]])] param(
    [Parameter(ValueFromPipeLine = $True, ValueFromPipelineByPropertyName = $True, Mandatory = $True)]
    [Alias('Name')][String]$CommandName
)

Add-Type -AssemblyName System.Web

function Text($String) {
    if ($String) {
        $Indent0 = $Null
        $Text = [System.Text.StringBuilder]::new()
        $NewLine = $False
        foreach ($Line in ($String -Split '[\r]?\n')) {
            $Trim = $Line.Trim()
            $Indent = if ($Line -Match '^\w*') { '^' + $Matches[0] } else { '^' }
            if ($Null -eq $Indent0 -and $Trim) { $Indent0 = $Indent }
            if ($Indent -ne $Indent0 -or $Trim -Match '^[*-\>]\w|\d+[\.\)]') { $NewLine = $True }
            if ($Text.Length -and $NewLine) { [void]$Text.AppendLine('  ') } else { [void]$Text.Append(' ') }
            $MDEncode = [System.Web.HttpUtility]::HtmlEncode($Trim)
            [void]$Text.Append($MDEncode)
            $NewLine = $Line -match '  $'
        }
        [void]$Text.AppendLine()
        $Text.ToString()
    }
}

$Command = Get-Command $CommandName
$Help = Get-Help -Detailed $CommandName

$Name = [System.IO.Path]::GetFileNameWithoutExtension($Command.Name)

"# $Name"
$Help.Synopsis

'## Syntax'
foreach ($SyntaxItem in $Help.Syntax.syntaxItem) {
        '```PowerShell'
    $Name
    foreach ($Parameter in $syntaxItem.Parameter) {
        $Text = [System.Text.StringBuilder]'    ['
        if ($Parameter.required -eq $True) { [void]$Text.Append('[') }
        [void]$Text.Append('-')
        [void]$Text.Append($Parameter.Name)
        if ($Parameter.required -eq $True) { [void]$Text.Append(']') }
        if ($Parameter.parameterValue) {
            [void]$Text.Append(' <')
            [void]$Text.Append($Parameter.parameterValue)
            [void]$Text.Append('>')
        }
        [void]$Text.Append(']')
        $Text.ToString()
    }
    '    [<CommonParameters>]'
    '```'
}

'## Description'
Text $Help.Description.Text

$Examples = $Help.Examples.Example
if ($Examples) { '## Examples' }
foreach ($Example in $Examples) {
    if ($Example.Title -Match '^-+ EXAMPLE (\d)+ -+$') {
        "### Example $($Matches[1])"
    }
    else {
        "### $($Example.Title)"
    }
    if ($Example.Introduction.Text -notmatch '^PS.*\>$') { $Example.Introduction.Text }
    '```PowerShell'
    $Example.Code
    '```' #'
    foreach ($Remark in $Example.Remarks) {
        Text $Remark.Text
    }
}

$Parameters = $Help.parameters.parameter
if ($Parameters) { '## Parameters' }
foreach ($Parameter in $Parameters) {
    "### ``-$($Parameter.Name)``"
    Text $Parameter.Description.Text
    '| <!--                    --> | <!-- --> |'
    '| --------------------------- | -------- |'
    $Attributes = $Command.Parameters[$Parameter.Name].Attributes
    if ($Null -ne $Attributes.MinLength -and $Null -ne $Attributes.MaxLength) { "| Accepted length             | $($Attributes.MinLength) - $($Attributes.MaxLength) |" }
    elseif ($Null -ne $Attributes.MinLength)                                  { "| Minimal length:             | $($Attributes.MinLemgth) |" }
    elseif ($Null -ne $Attributes.MaxLength)                                  { "| Maximal lemgth:             | $($Attributes.MaxLength) |" }
    if ($Null -ne $Attributes.RegexPattern)                                   { "| Accepted pattern:           | ``$($Attributes.RegexPattern)`` |" }
    if ($Null -ne $Attributes.MinRange -and $Null -ne $Attributes.MaxRange)   { "| Accepted range:             | $($Attributes.MinRange) - $($Attributes.MaxRange) |" }
    elseif ($Null -ne $Attributes.MinRange)                                   { "| Minimal value:              | $($Attributes.MinRange) |" }
    elseif ($Null -ne $Attributes.MaxRange)                                   { "| Maximal value:              | $($Attributes.MaxRange) |" }
    if ($Null -ne $Attributes.ScriptBlock)                                    { "| Accepted script condition:  | ``$($Attributes.ScriptBlock.ToString().Trim() -Split '\s*[\r?\n]\s*' -Join '; ')`` |" }
    if ($Null -ne $Attributes.ValidValues)                                    { "| Accepted values:            | $($Attributes.ValidValues -Join ', ') |" }
    $TypeName = $Parameter.parameterValue
    $TypeUri = 'https://docs.microsoft.com/en-us/dotnet/api/' + $Command.Parameters[$Parameter.Name].ParameterType.FullName
    "| Type:                       | [$TypeName]($TypeUri) |"
    if ($Attributes.Aliases) { "| Aliases:                    | $(Attributes.Aliases -Join ', ') |" }
    "| Position:                   | $($Parameter.Position) |"
    "| Default value:              | $($Parameter.defaultValue) |"
    "| Accept pipeline input:      | $($Parameter.pipelineInput) |"
    "| Accept wildcard characters: | $($Parameter.globbing) |"
}