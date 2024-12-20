<#
.SYNOPSIS
    Start an Activity.
.PARAMETER Name
    The name of the activity.
.PARAMETER Kind
    An Activity.Kind for this Activity.
      - Internal: Internal operation within an application, as opposed to operations with remote parents or children. This is the default value.
      - Server: Requests incoming from external component
      - Client: Outgoing request to the external component
      - Producer: Output provided to external components
      - Consumer: Output received from an external component
.PARAMETER ActivitySource
    An ActivitySource.
.LINK
    New-ActivitySource
.LINK
    https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs
.NOTES
    Activity is the .Net implementation of an OpenTelemetry "Span".
    If there are no registered listeners or there are listeners that are not interested, Start-Activity
    will return null and avoid creating the Activity object. This is a performance optimization so that
    the code pattern can still be used in functions that are called frequently.
#>
function Start-Activity {
    [CmdletBinding()]
    [OutputType('System.Diagnostics.Activity')]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,

        [Parameter(Position = 1)]
        [System.Diagnostics.ActivityKind]
        $Kind = [System.Diagnostics.ActivityKind]::Internal,

        [Parameter(Mandatory, Position = 2, ValueFromPipeline)]
        [System.Diagnostics.ActivitySource]
        $ActivitySource
    )

    $ActivitySource.StartActivity($Name, $Kind)
}