<#
.SYNOPSIS
    Add a timestamped message to an Activity.
.DESCRIPTION
    Add a timestamped message to an Activity.
.PARAMETER Message
    The message string for the ActivityEvent.
.PARAMETER Activity
    An instance of an Activity.
.NOTES
    Events are timestamped messages that can attach an arbitrary stream of additional diagnostic data to Activities.
.LINK
    Start-Activity
#>
function Add-ActivityEvent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Message,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [System.Diagnostics.Activity]
        $Activity
    )

    if ($null -ne $Activity) {
        $activityEvent = [System.Diagnostics.ActivityEvent]::new($Message)
        $Activity.AddEvent($activityEvent)
    }
}