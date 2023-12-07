function New-TracerProviderBuilder {
	<#
	.SYNOPSIS
		Creates new Tracer Provider Builder
	.DESCRIPTION
		Creates instance of OpenTelemetry.Sdk TracerProviderBuilder
	.INPUTS
		None. You cannot pipe objects to  New-TracerBuilder
	.OUTPUTS
		TracerProviderBuilder
	.EXAMPLE
		PS> New-TracerProviderBuilder
	.EXAMPLE
		PS> New-TracerProviderBuilder -ActivyName "MyActivity"
    .LINK
        https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry/Sdk.cs
	#>
	[CmdletBinding(DefaultParameterSetName = "byString")]
	param (
		[Parameter(Position = 0, ParameterSetName = "byString")]
		[string]
		$ActivityName,

		[Parameter(Position = 0, ParameterSetName = "byActivity")]
		[System.Diagnostics.ActivitySource]
		$ActivitySource
	)


	if ($PSBoundParameters.ContainsKey('ActivityName')) {
		$ActivitySource = New-ActivitySource -Name $ActivityName
	}

	if ($null -ne $ActivitySource) {
		[OpenTelemetry.Sdk]::CreateTracerProviderBuilder() | Add-TracerSource -ActivitySource $ActivitySource
	}
	else {
		[OpenTelemetry.Sdk]::CreateTracerProviderBuilder()
	}

}