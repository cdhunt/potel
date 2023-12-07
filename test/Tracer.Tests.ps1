BeforeAll {
    Import-Module $PSScriptRoot/../publish/potel -Force
    $modulePath = Get-Module potel | Select-Object -ExpandProperty Path | Split-Path -Parent

    $addTypes = Join-Path -Path $modulePath -ChildPath internal -AdditionalChildPath Add-PackageTypes.ps1
    . "$addTypes"

    Add-PackageTypes -LibsDirectory "$modulePath/lib"
}

Describe 'New-TracePRoviderBuilder' {
    Context 'No Parameters' {
        It 'Returns a new TracerProviderBuilder' -Tag 'trace' {
            $result = New-TracerProviderBuilder
            $result.GetType().FullName | Should -Be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
        }
    }
    Context 'ActivityName Parameter' {
        BeforeAll {
            Mock -ModuleName potel Add-TracerSource { return [OpenTelemetry.Sdk]::CreateTracerProviderBuilder().AddSource("TestSource") }
            Mock -ModuleName potel New-ActivitySource { return [System.Diagnostics.ActivitySource]::new("TestSource") }
        }

        It 'Returns a new TracerProviderBuilder' -Tag 'trace' {
            $result = New-TracerProviderBuilder -ActivityName "TestSource"
            $result.GetType().FullName | Should -Be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
            Should -Invoke New-ActivitySource -ModuleName potel -Times 1 -ParameterFilter {
                $Name -eq "TestSource"
            }
            Should -Invoke Add-TracerSource -ModuleName potel -Times 1 -ParameterFilter {
                $null -eq $Name
                $null -ne $ActivitySource
            }
        }
    }

    Context 'ActivitySource Prarameter' {
        BeforeAll {
            Mock -ModuleName potel Add-TracerSource { return [OpenTelemetry.Sdk]::CreateTracerProviderBuilder().AddSource("TestSource") }
            Mock -ModuleName potel New-ActivitySource { return [System.Diagnostics.ActivitySource]::new("TestSource") }
        }

        It 'Returns a new TracerProviderBuilder' -Tag 'trace' {
            $result = New-TracerProviderBuilder -ActivitySource ([System.Diagnostics.ActivitySource]::new("TestSource"))
            $result.GetType().FullName | Should -Be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
            Should -Invoke New-ActivitySource -ModuleName potel -Times 0
            Should -Invoke Add-TracerSource -ModuleName potel -Times 1 -ParameterFilter {
                $null -eq $Name
                $null -ne $ActivitySource
            }
        }
    }
}

Describe 'New-ActivitySource' {
    It 'Returns a new System.Diagnostics.ActivitySource' -Tag 'trace' {
        $result = New-ActivitySource -Name 'TestSource'
        $result.GetType().FullName | Should -be 'System.Diagnostics.ActivitySource'
        $result.Name | Should -Be 'TestSource'
    }
}

Describe 'Add-TracerSource' {}

AfterAll {
    Remove-Module potel
}