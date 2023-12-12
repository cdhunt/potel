<#
.SYNOPSIS
    Start the Tracer
.LINK
    New-TracerProviderBuilder
#>
function Start-Tracer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $InputObject,

        [Parameter()]
        [switch]$PassThru
    )

    $global:potel_provider = [OpenTelemetry.Trace.TracerProviderBuilderExtensions]::Build($InputObject)

    if ($PassThru) {
        Write-Output $potel_provider
    }
}