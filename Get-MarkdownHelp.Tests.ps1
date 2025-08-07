#Requires -Modules @{ModuleName="Pester"; ModuleVersion="5.0.0"}

[Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssignments', 'ScriptFile', Justification = 'False positive')]
[Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssignments', 'ModuleFile', Justification = 'False positive')]
param ()

Describe 'Get-MarkdownHelp' {

    BeforeAll {

        # Set-StrictMode -Version Latest

        $Value = $PSCommandPath -Replace '.Tests.ps1$', '.ps1'
        $Name = [System.IO.Path]::GetFileNameWithoutExtension($Value)
        Set-Alias -Name $Name -Value $Value

        $ScriptName = 'TestFunction'
        $ScriptFile = "$($Env:Temp)\$ScriptName"
        $ModuleName = "Get-MarkdownHelp.TestScript.psm1"
        $ModuleFile = "$($Env:Temp)\$ModuleName"

        $Null, 1, 2 |Foreach-Object {
            Set-Variable -Name TestHelp$_ -Value @"
<#
  .SYNOPSIS
    Test

  .DESCRIPTION
    This is a script with the code in the root

  .PARAMETER InputObject$_
    InputObject$_ parameter test

  .PARAMETER Switch
    Switch parameter test
#>
"@

            Set-Variable -Name TestParam$_ -Value "
    param(
        [Parameter(Mandatory = `$True, ValueFromPipeLine = `$True)]`$InputObject$_,
        [Switch]`$Switch$_
    )
"

            Set-Variable -Name TestFunction$_ -Value @"
function TestFunction$_ {
$TestHelp$_
$TestParam$_
}
"@
        }
    }

    Context 'input' {

        It 'ps1 file' {
            $TestScript = @"
$TestHelp
$TestParam
"@
            $ScriptBlock = [ScriptBlock]::Create($TestScript)
            $ScriptBlock | Out-File $ScriptFile
            $MarkdownHelp = Get-MarkdownHelp $ScriptFile
            $MarkdownHelp | Should -Contain "# $ScriptName"
            $MarkdownHelp | Should -Contain '## Description'
        }

        It 'psm1 file' {
            $TestModule = @"
$TestHelp
function TestFunction {
$TestParam
}
Export-ModuleMember -Function TestFunction
"@
            $ScriptBlock = [ScriptBlock]::Create($TestModule)
            $ScriptBlock | Out-File $ModuleFile
            $MarkdownHelp = Get-MarkdownHelp $ModuleFile
            $MarkdownHelp | Should -Contain "# $ScriptName"
            $MarkdownHelp | Should -Contain '## Description'
        }

        It 'ps1 file with embedded function' {
            $TestScript = @"
$TestHelp
function TestFunction {
$TestParam
}
"@
            $ScriptBlock = [ScriptBlock]::Create($TestScript)
            $ScriptBlock | Out-File $ScriptFile
            $MarkdownHelp = Get-MarkdownHelp $ScriptFile -Command TestFunction
            $MarkdownHelp | Should -Contain '# TestFunction'
            $MarkdownHelp | Should -Contain '## Description'
        }


        It 'ps1 file with embedded function and help' {
            $TestScript = @"
function TestFunction {
$TestParam
$TestHelp
}
"@
            $ScriptBlock = [ScriptBlock]::Create($TestScript)
            $ScriptBlock | Out-File $ScriptFile
            $MarkdownHelp = Get-MarkdownHelp $ScriptFile -Command TestFunction
            $MarkdownHelp | Should -Contain '# TestFunction'
            $MarkdownHelp | Should -Contain '## Description'
        }
    }

    Context 'Github issues' {

        It 'Issue #9 Add -Script parameter' {
            $Script = {
<#
    .SYNOPSIS
    Test

    .DESCRIPTION
    Testing the -Script parameter
#>

function Test { }
}

            $MarkdownHelp = Get-MarkdownHelp -Script $Script
            $MarkdownHelp | Should -Contain '# Test'
            $MarkdownHelp | Should -Contain '## Description'
        }

        It 'Issue #10 Embedded Here-Comment breaks parsing' {
            $Script = {
# .SYNOPSIS
# Test
#
# .DESCRIPTION
# Testing the -Script parameter
#
# .EXAMPLE
# #Embedded Here-Comment:
#
#     Write-Host 1
#     <# 100 #> Write-Host 2
#     Write-Host 3

function Test { }
}

            $MarkdownHelp = Get-MarkdownHelp -Script $Script
            $MarkdownHelp | Should -Contain 'Write-Host 1'
            $MarkdownHelp | Should -Contain '<# 100 #> Write-Host 2'
            $MarkdownHelp | Should -Contain 'Write-Host 3'
        }
    }

    AfterAll {

        # if (Test-Path -LiteralPath $ScriptFile) { Remove-Item -LiteralPath $ScriptFile }
        # if (Test-Path -LiteralPath $ModuleFile) { Remove-Item -LiteralPath $ModuleFile }
    }
}