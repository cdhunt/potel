<#
.SYNOPSIS
    Get the contents of the diagnostic log.
.DESCRIPTION
    Read the contents of the file ExecutableName.ProcessId.log from the path specified with Enable-OtelDiagnosticLog.
.LINK
    Enable-OtelDiagnosticLog
.EXAMPLE
    Get-OtelDiagnosticLog

    Get the internal logs.
#>
function Get-OtelDiagnosticLog {
    [CmdletBinding()]
    param ()

    $configName = 'OTEL_DIAGNOSTICS.json'
    $configPath = Join-Path -Path ([System.IO.Directory]::GetCurrentDirectory()) -ChildPath $configName

    if (Test-Path -Path $configPath) {
        $config = Get-Content -Path $configPath
        $settings = $config | ConvertFrom-Json

        $executableName = Get-Process -Id $PID | Select-Object -ExpandProperty ProcessName
        $logName = '{0}.exe.{1}.log' -f $executableName, $PID

        $logPath = Join-Path -Path $settings.LogDirectory -ChildPath $logName

        Get-Content -Path $logPath
    }
}