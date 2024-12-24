<#
.SYNOPSIS
	Adds Http Client Instrumentation
.DESCRIPTION
	Adds Http Client Instrumentation
.PARAMETER TracerProvider
	Instance of TracerProviderBuilderBase.
.INPUTS
	Instance of TracerProviderBuilderBase
.OUTPUTS
	TracerProviderBuilderBase
.EXAMPLE
	New-TracerProviderBuilder | Add-HttpClientInstrumentation
.LINK
	New-TracerProviderBuilder
.LINK
    New-HttpClientTraceInstrumentationOption
.LINK
	https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md
#>
function Add-HttpClientInstrumentation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider,

        [Parameter(Position = 0)]
        [Action[OpenTelemetry.Instrumentation.Http.HttpClientTraceInstrumentationOptions]]
        $Options
    )

    [OpenTelemetry.Trace.HttpClientInstrumentationTracerProviderBuilderExtensions]::AddHttpClientInstrumentation($TracerProvider, $null, $Options)

}