<#
.SYNOPSIS
    Enable the internal logs generated by all OpenTelemetry components.
.DESCRIPTION
    Create the `OTEL_DIAGNOSTICS.json` file to enable the internal logs generated by all OpenTelemetry components.
.PARAMETER LogDirectory
    The directory where the output log file will be stored. It can be an absolute path or a relative path to the current directory. Default is current directory.
.PARAMETER FileSize
    Specifies the log file size in KiB. The log file will never exceed this configured size, and will be overwritten in a circular way. Default is `32768`.
.PARAMETER LogLevel
    The lowest level of the events to be captured. Default is `Warning`.
.NOTES
    The self-diagnostics feature can be enabled/changed/disabled while the process is running (without restarting the process). The SDK will attempt to read the configuration file every 10 seconds in non-exclusive read-only mode. The SDK will create or overwrite a file with new logs according to the configuration. This file will not exceed the configured max size and will be overwritten in a circular way.

    A log file named as `ExecutableName.ProcessId.log` (e.g. pwsh.exe.12345.log) will be generated at the specified directory LogDirectory, into which logs are written to.
.LINK
    Disable-OtelDiagnosticLog
.LINK
    https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/src/OpenTelemetry#self-diagnostics
.EXAMPLE
    Enable-OtelDiagnosticLog -LogDirectory C:\logs

    Write an Otel Diagnostic log to C:\logs.
.EXAMPLE
    Enable-OtelDiagnosticLog -LogLevel Warning

    Includes the Error and Critical levels.
#>
function Enable-OtelDiagnosticLog {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [Alias("Path", "PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogDirectory = '.',

        [Parameter(Position = 1)]
        [ValidateRange(1024, 131072)]
        [int]
        $FileSize = 32768,

        [Parameter(Position = 2)]
        [System.Diagnostics.Tracing.EventLevel]
        $LogLevel = 'Warning'
    )

    $name = 'OTEL_DIAGNOSTICS.json'
    $settings = [pscustomobject]@{
        LogDirectory = $LogDirectory
        FileSize     = $FileSize
        $LogLevel    = $LogLevel.ToString()
    }
    $content = $settings | ConvertTo-Json
    $path = Join-Path -Path ([System.IO.Directory]::GetCurrentDirectory()) -ChildPath $name

    $content | Set-Content -Path $path

}