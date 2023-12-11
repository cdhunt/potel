<#
.SYNOPSIS
    Create a new ActivitySource object
#>
function New-ActivitySource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name

    )

    [System.Diagnostics.ActivitySource]::new($Name)
}