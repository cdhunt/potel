<#
.SYNOPSIS
    Disable the internal logs generated by all OpenTelemetry components.
.DESCRIPTION
    Remove the `OTEL_DIAGNOSTICS.json` file to disabled the internal logs generated by all OpenTelemetry components.
.PARAMETER RemoveLog

.LINK
    Enable-OtelDiagnosticLog
.EXAMPLE
    Disable-OtelDiagnosticLog

    Disable the internal logs.
#>
function Disable-OtelDiagnosticLog {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $RemoveLog
    )

    $name = 'OTEL_DIAGNOSTICS.json'
    $path = Join-Path -Path ([System.IO.Directory]::GetCurrentDirectory()) -ChildPath $name

    Remove-Item -Path $path

    if ($RemoveLog) {
        Write-Information "Sleeping for 10 seconds to allow SDK to reconfigure diagnostics."
        Start-Sleep -Seconds 10
        Get-OtelDiagnosticLog | Remove-Item
    }
}