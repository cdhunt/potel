<#
.SYNOPSIS
    Create an instance of ActivitySource.
.DESCRIPTION
    Create an instance of ActivitySource. ActivitySource provides APIs to create and start Activity objects.
.PARAMETER Name
    The Source Name. The source name passed to the constructor has to be unique to avoid the conflicts with any other sources.
.PARAMETER Version
    The version parameter is optional.
.LINK
    Start-Activity
.LINK
    https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs#activitysource
.NOTES
    ActivitySource is the .Net implementation of an OpenTelemetry "Tracer"
#>
function New-ActivitySource {
    [CmdletBinding()]
    [OutputType('System.Diagnostics.ActivitySource')]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,

        [Parameter(Position = 1)]
        [string]
        $Version = [string]::Empty
    )

    [System.Diagnostics.ActivitySource]::new($Name, $Version)
}