<#
.SYNOPSIS
    Start the Tracer
.PARAMETER TracerProviderBuilder
    A TracerProviderBuilderBase object
.PARAMETER PassThru
    Send the build TracerProvider to the pipeline
.LINK
    New-TracerProviderBuilder
#>
function Start-Tracer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProviderBuilder,

        [Parameter()]
        [switch]$PassThru
    )

    $global:potel_provider = [OpenTelemetry.Trace.TracerProviderBuilderExtensions]::Build($TracerProviderBuilder)

    if ($PassThru) {
        Write-Output $potel_provider
    }
}