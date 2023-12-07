BeforeAll {
    Import-Module $PSScriptRoot/../publish/potel -Force
    $modulePath = Get-Module potel | Select-Object -ExpandProperty Path | Split-Path -Parent

    $addTypes = Join-Path -Path $modulePath -ChildPath internal -AdditionalChildPath Add-PackageTypes.ps1
    . "$addTypes"

    Add-PackageTypes -LibsDirectory "$modulePath/lib"
}

Describe 'New-TracePRoviderBuilder' {
    Context 'No Parameters' {
        It 'Returns a new TracerProviderBuilder' -Tag @('unit', 'trace') {
            $result = New-TracerProviderBuilder
            $result.GetType().FullName | Should -Be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
        }
    }
    Context 'ActivityName Parameter' {
        BeforeAll {
            Mock -ModuleName potel Add-TracerSource { return [OpenTelemetry.Sdk]::CreateTracerProviderBuilder().AddSource("TestSource") }
            Mock -ModuleName potel New-ActivitySource { return [System.Diagnostics.ActivitySource]::new("TestSource") }
        }

        It 'Returns a new TracerProviderBuilder' -Tag @('unit', 'trace') {
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

        It 'Returns a new TracerProviderBuilder' -Tag @('unit', 'trace') {
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
    It 'Returns a new System.Diagnostics.ActivitySource' -Tag @('unit', 'trace') {
        $result = New-ActivitySource -Name 'TestSource'
        $result.GetType().FullName | Should -be 'System.Diagnostics.ActivitySource'
        $result.Name | Should -Be 'TestSource'
    }
}

Describe 'Add-TracerSource' {
    Context 'Name Parameter' {
        It 'Should accept a string name' -Tag @('unit', 'trace') {
            { New-TracerProviderBuilder | Add-TracerSource -Name "MyActivity" } | Should -Not -Throw
        }
    }

    Context 'ActivitySource Prarameter' {
        It 'Should accept a Diagnostics.ActivitySource' -Tag @('unit', 'trace') {
            { $source = New-ActivitySource -Name "MyActivity"
                New-TracerProviderBuilder | Add-TracerSource -ActivitySource $source } | Should -Not -Throw
        }
    }
}

Describe 'Add-HttpClientInstrumentation' {
    It 'Should find type OpenTelemetry.Instrumentation.Http' -Tag @('unit', 'trace') {
        { New-TracerProviderBuilder -ActivityName "TestSource" | Add-HttpClientInstrumentation } | Should -Not -Throw
    }
}

Describe 'Add-ExporterOtlpTrace' {
    BeforeEach {
        Remove-Item env:\OTEL_EXPORTER_OTLP_ENDPOINT -ErrorAction SilentlyContinue
        Remove-Item env:\OTEL_EXPORTER_OTLP_HEADERS -ErrorAction SilentlyContinue
        Remove-Item env:\OTEL_EXPORTER_OTLP_TIMEOUT -ErrorAction SilentlyContinue
        Remove-Item env:\OTEL_EXPORTER_OTLP_PROTOCOL -ErrorAction SilentlyContinue
    }

    It 'Should work with TracerProviderBuilder' -Tag @('unit', 'trace') {
        $result = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/
        $result.GetType().FullName | Should -be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
        $env:OTEL_EXPORTER_OTLP_ENDPOINT | Should -Be 'http://tracer/'
    }

    It 'Should work with MeterProviderBuilder' -Tag @('unit', 'metric') {
        $result = [OpenTelemetry.Sdk]::CreateMeterProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://meter/
        $result.GetType().FullName | Should -be 'OpenTelemetry.Metrics.MeterProviderBuilderBase'
        $env:OTEL_EXPORTER_OTLP_ENDPOINT | Should -Be 'http://meter/'
    }

    It 'Should set $env:OTEL_EXPORTER_OTLP_HEADERS with Headers parameter' -Tag @('unit', 'trace') {
        $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Headers @{"header1" = "value1"; "header2" = "value2" }
        $env:OTEL_EXPORTER_OTLP_HEADERS | Should -BeLikeExactly "*header1=value1*"
        $env:OTEL_EXPORTER_OTLP_HEADERS | Should -BeLikeExactly "*header2=value2*"
        $env:OTEL_EXPORTER_OTLP_HEADERS | Should -BeLikeExactly "header?=value?,header?=value?"
    }

    It 'Should set $env:OTEL_EXPORTER_OTLP_TIMEOUT with Timeout parameter' -Tag @('unit', 'trace') {
        $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Timeout 100
        $env:OTEL_EXPORTER_OTLP_TIMEOUT | Should -Be 100
    }

    It 'Should set throw with a negative Timeout parameter' -Tag @('unit', 'trace') {
        { $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Timeout -1 } | Should -Throw
        $env:OTEL_EXPORTER_OTLP_TIMEOUT | Should -BeNullOrEmpty
    }

    It 'Should set $env:OTEL_EXPORTER_OTLP_PROTOCOL with Protocol parameter (grpc)' -Tag @('unit', 'trace') {
        $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Protocol grpc
        $env:OTEL_EXPORTER_OTLP_PROTOCOL | Should -Be 'grpc'
    }

    It 'Should set $env:OTEL_EXPORTER_OTLP_PROTOCOL with Protocol parameter (http/protobuf)' -Tag @('unit', 'trace') {
        $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Protocol 'http/protobuf'
        $env:OTEL_EXPORTER_OTLP_PROTOCOL | Should -Be 'http/protobuf'
    }

    It 'Should set throw with a bad Protocol parameter' -Tag @('unit', 'trace') {
        { $null = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterOtlpTrace -Endpoint http://tracer/ -Protocol 'magic' } | Should -Throw
        $env:OTEL_EXPORTER_OTLP_PROTOCOL | Should -BeNullOrEmpty
    }

    Describe 'Add-ExporterConsole' {

        It 'Should work with TracerProviderBuilder' -Tag @('unit', 'trace') {
            $result = [OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-ExporterConsole
            $result.GetType().FullName | Should -be 'OpenTelemetry.Trace.TracerProviderBuilderBase'
        }

        It 'Should work with MeterProviderBuilder' -Tag @('unit', 'metric') {
            $result = [OpenTelemetry.Sdk]::CreateMeterProviderBuilder() | Add-ExporterConsole
            $result.GetType().FullName | Should -be 'OpenTelemetry.Metrics.MeterProviderBuilderBase'
        }
    }
}

AfterAll {
    Remove-Module potel
}