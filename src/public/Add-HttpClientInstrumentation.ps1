<#
.SYNOPSIS
	Adds Http Client Instrumentation.
.DESCRIPTION
	Adds Http Client Instrumentation.
.PARAMETER TracerProvider
	Instance of TracerProviderBuilderBase.
.PARAMETER RequestFilter
    A filter function that determines whether or not to collect telemetry on a per request basis. Must return a `[bool]` and act on an instance of `[Net.Http.HttpRequestMessage]`.
.PARAMETER RecordException
    Indicating whether exception will be recorded ActivityEvent or not. This instrumentation automatically sets Activity Status to Error if the Http StatusCode is >= 400. Additionally, `RecordException` feature may be turned on, to store the exception to the Activity itself as ActivityEvent.
.INPUTS
	Instance of TracerProviderBuilderBase
.OUTPUTS
	TracerProviderBuilderBase
.EXAMPLE
	New-TracerProviderBuilder | Add-HttpClientInstrumentation

    Enabled the zero-code instrumentation of System.Net.Http.HttpClient methods.
.EXAMPLE
	New-TracerProviderBuilder | Add-HttpClientInstrumentation { $_.Method -eq 'Get' }

    Only collect web requests with a `Method` of `Get`.
.EXAMPLE
	New-TracerProviderBuilder | Add-HttpClientInstrumentation  { $this.RequestUri -like '*google.com*' }

    Only collect web requests sent to the "google.com" domain.
.LINK
	New-TracerProviderBuilder
.LINK
	https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md
.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties
#>
function Add-HttpClientInstrumentation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider,

        [Parameter(Position = 0)]
        [scriptblock]
        $RequestFilter = { $true },

        [Parameter()]
        [switch]
        $RecordException
    )

    $options = {
        param([OpenTelemetry.Instrumentation.Http.HttpClientTraceInstrumentationOptions]$o)

        $o.FilterHttpRequestMessage = { param([Net.Http.HttpRequestMessage]$request)
            $context = [system.Collections.Generic.List[PSVariable]]::new()
            $context.Add([PSVariable]::new('_', $request))
            $context.Add([PSVariable]::new('this', $request))
            $context.Add([PSVariable]::new('PSItem', $request))
            $RequestFilter.InvokeWithContext($null, $context)
        }

        $o.RecordException = $RecordException

    }.GetNewClosure()

    [OpenTelemetry.Trace.HttpClientInstrumentationTracerProviderBuilderExtensions]::AddHttpClientInstrumentation($TracerProvider, $null, $options)

}