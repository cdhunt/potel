function Add-ExporterConsole {
    <#
	.SYNOPSIS
		Adds a Console Exporter
	.DESCRIPTION
		Adds OpenTelemetry.Exporter.Console
	.PARAMETER InputObject
		Instance of TracerProviderBuilderBase.
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		New-TracerBuilder | Add-HttpClientInstrumentation
    .LINK
        New-TracerBuilder
    .LINK
        Add-HttpClientInstrumentation
	#>
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ParameterSetName = "Trace" )]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider,

        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ParameterSetName = "Meter" )]
        [OpenTelemetry.Metrics.MeterProviderBuilderBase]
        $MeterBuilder
    )

    switch ($PSBoundParameters) {
        { $_.ContainsKey('TracerProvider') } { [OpenTelemetry.Trace.ConsoleExporterHelperExtensions]::AddConsoleExporter($TracerProvider) }
        { $_.ContainsKey('MeterBuilder') } { [OpenTelemetry.Metrics.ConsoleExporterMetricsExtensions]::AddConsoleExporter($MeterBuilder) }
    }

}