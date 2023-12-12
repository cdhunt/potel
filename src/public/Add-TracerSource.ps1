function Add-TracerSource {
    <#
	.SYNOPSIS
		Adds Http Client Instrumentation
	.DESCRIPTION
		Adds Http Client Instrumentation
	.PARAMETER InputObject
		Instance of TracerProviderBuilderBase.
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		New-TracerProviderBuilder | Add-TracerSource -Name "MyActivity"

        Add a source by Name.
	.EXAMPLE
		$source = New-ActivitySource -Name "MyActivity"
		New-TracerProviderBuilder | Add-TracerSource -AcvititySource $source

        Create an Activity Soruce object.
    .LINK
        New-TracerProviderBuilder
    .LINK
        New-ActivitySource
	#>
    [CmdletBinding(DefaultParameterSetName = "byString")]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = "byString")]
        [string[]]
        $Name,

        [Parameter(Mandatory, Position = 0, ParameterSetName = "byActivity")]
        [System.Diagnostics.ActivitySource]
        $ActivitySource,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProviderBuilder
    )

    if ($PSBoundParameters.ContainsKey('ActivitySource')) {
        $Name = $ActivitySource.Name
    }

    $TracerProviderBuilder.AddSource($Name)
}