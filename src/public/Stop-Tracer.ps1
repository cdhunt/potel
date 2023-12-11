<#
.SYNOPSIS
    Stop the Tracer
#>
function Stop-Tracer {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProvider]
        $TracerProvider = $global:potel_provider

    )

    $result = [OpenTelemetry.Trace.TracerProviderExtensions]::Shutdown($TracerProvider) # For exporter
    $TracerProvider.Dispose() # For Instrumentation

    if (!$result) {
        Write-Warning "Tracer Shutdown operation did not return True"
    }
}