<#
.SYNOPSIS
    Options for HttpClient instrumentation.
.DESCRIPTION
    Initializes a new instance of the HttpClientTraceInstrumentationOptions class for HttpClient instrumentation.
.PARAMETER RequestFilter
    A filter function that determines whether or not to collect telemetry on a per request basis.
.PARAMETER RecordException
    Indicating whether exception will be recorded ActivityEvent or not. This instrumentation automatically sets Activity Status to Error if the Http StatusCode is >= 400. Additionally, `RecordException` feature may be turned on, to store the exception to the Activity itself as ActivityEvent.
.NOTES
    Filter scriptblock must return a bool. `[Func[Net.Http.HttpRequestMessage, bool]]`
.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties
.EXAMPLE
    $options = New-HttpClientTraceInstrumentationOption -RequestFilter {param([Net.Http.HttpRequestMessage]$request) $request.Method -eq 'Get' }
    New-TracerProviderBuilder | Add-HttpClientInstrumentation -Options $options

    Collect only web requests with a `Method` of `Get`.
.EXAMPLE
    $options = New-HttpClientTraceInstrumentationOption -RequestFilter {param([Net.Http.HttpRequestMessage]$request) $request.RequestUri -like '*google.com*' }
    New-TracerProviderBuilder | Add-HttpClientInstrumentation -Options $options

    Collect only web requests send to the "google.com" domain.
#>
function New-HttpClientTraceInstrumentationOption {
    [CmdletBinding()]
    [OutputType('OpenTelemetry.Instrumentation.Http.HttpClientTraceInstrumentationOptions')]
    param (
        [Parameter(Position = 0)]
        [Func[Net.Http.HttpRequestMessage, bool]]
        $RequestFilter,

        [Parameter()]
        [switch]
        $RecordException
    )

    $options = {
        param([OpenTelemetry.Instrumentation.Http.HttpClientTraceInstrumentationOptions]$o)
        $o.FilterHttpRequestMessage = $RequestFilter
        $o.RecordException = $RecordException
    }

    $options.GetNewClosure() | Write-Output
}