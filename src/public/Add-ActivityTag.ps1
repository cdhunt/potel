<#
.SYNOPSIS
    Add key-value data called Tags to an Activity.
.DESCRIPTION
    Add key-value data called Tags to an Activity.
.PARAMETER Tags
    A collection of key/value pairs.
.PARAMETER Activity
    An instance of an Activity.
.NOTES
    Commonly used to store any parameters of the work that may be useful for diagnostics
.LINK
    Start-Activity
#>
function Add-ActivityTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [hashtable]
        $Tags,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [System.Diagnostics.Activity]
        $Activity
    )

    if ($null -ne $Activity) {
        foreach ($entry in $Tags.GetEnumerator()) {
            $Activity.AddTag($entry.Key, $entry.Value)
        }
    }
}