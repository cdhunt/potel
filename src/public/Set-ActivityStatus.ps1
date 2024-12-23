<#
.SYNOPSIS
    Set the Activity Status.
.DESCRIPTION
    OpenTelemetry allows each Activity to report a Status that represents the pass/fail result of the work.
.PARAMETER StatusCode
    An ActivityStatusCode. The ActivityStatusCode values are represented as either, `Unset`, `Ok`, and `Error`.
.PARAMETER Description
    Optional Description that provides a descriptive message of the Status. `Description` **MUST** only be used with the `Error` `StatusCode` value.
.NOTES
    StatusCode is one of the following values:
    - Unset: The default status.
    - Ok: The operation has been validated by an Application developer or Operator to have completed successfully.
    - Error: The operation contains an error.
.LINK
    Start-Activity
#>
function Set-ActivityStatus {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [System.Diagnostics.ActivityStatusCode]
        $StatusCode,

        [Parameter(Position = 1)]
        [string]
        $Description,

        [Parameter(Mandatory, Position = 2, ValueFromPipeline)]
        [System.Diagnostics.Activity]
        $Activity
    )

    if ($PSBoundParameters.ContainsKey('Description') -and $StatusCode -ne [System.Diagnostics.ActivityStatusCode]::Error ) {
        $Description = $null
        Write-Warning "Description MUST only be used with the Error StatusCode value."
    }

    if ($null -ne $Activity) {
        $Activity.SetStatus($StatusCode, $Description)
    }
}