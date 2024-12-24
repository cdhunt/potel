# The Activity Source binds Activities (Spans) to a Tracer.
$activitySource = New-ActivitySource -Name potel-sample

# Only collect HttpClient requests to the google.com domain
$options = New-HttpClientTraceInstrumentationOption -RequestFilter {
    param([Net.Http.HttpRequestMessage]$request) $request.RequestUri -like '*google.com*'
}

# A Tracer provides the configuration and lifecycle of  your instrumentation.
# The Tracer does nothing itself, but binds inputs and outputs.
New-TracerProviderBuilder |
Add-TracerSource -ActivitySource $activitySource |
Add-ResourceConfiguration -ServiceName potel-sample -Attribute @{"host.name" = $(hostname) } |
Add-HttpClientInstrumentation -Options $options |
Add-ExporterOtlpTrace -Endpoint http://localhost:4317 |
Add-ExporterConsole |
Start-Tracer

# Enabled the internal Otel SDK log
$diagConfig = Enable-OtelDiagnosticLog -LogLevel Warning

function Get-SampleSomething {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [int]
        $SecondsToWait
    )

    # An Activity defines a unit of work and has a start and a stop.
    # Each Activity is equivalent to an Otel Span.
    $activity = $activitySource | Start-Activity -Name "Get-SampleSomething"

    # Activities have lots of available metadata you can use to enrich your spans.
    $activity | Add-ActivityTag @{'SecondsToWait' = $SecondsToWait }

    # Activity Events are timestamped log entries within an Activity
    $activity | Add-ActivityEvent -Message "About to go to sleep"

    Start-Sleep -Seconds $SecondsToWait

    $activity | Add-ActivityEvent -Message "Finished sleeping"

    Get-Google

    # You can explicitly stop an activity to capture accurate timing
    $activity.Stop()
}

function Get-Google {
    [CmdletBinding()]
    param (

    )

    # You can nest Activities. Since "Get-Google" Activity is started while the "Get-SampleSomething" Activity it will be a child of "Get-SampleSomething".
    $activity = $activitySource | Start-Activity -Name "Get-Google"

    # Calls to methods that are part of HttpClient class will automatically create child spans because we included Add-HttpClientInstrumentation.
    # https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md
    Invoke-WebRequest -Uri https://google.com | Out-Null

    $activity.Stop()

}