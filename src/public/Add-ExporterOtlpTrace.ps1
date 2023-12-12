function Add-ExporterOtlpTrace {
    <#
	.SYNOPSIS
		Adds an OTLP Exporter
	.DESCRIPTION
		Adds OpenTelemetry.Exporter.Console
	.PARAMETER InputObject
		Instance of TracerProviderBuilderBase.
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		PS> New-TracerBuilder | Add-HttpClientInstrumentation
    .LINK
        New-TracerBuilder
    .LINK
        Add-HttpClientInstrumentation
	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Trace")]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Meter" )]
        [OpenTelemetry.Metrics.MeterProviderBuilderBase]
        $MeterBuilder,

        [Parameter(Mandatory, Position = 0)]
        [string]
        $Endpoint,

        [Parameter(Position = 1)]
        [hashtable]
        $Headers,

        [Parameter(Position = 2)]
        [uint]
        $Timeout,

        [Parameter(Position = 3)]
        [ValidateSet('grpc', 'http/protobuf')]
        [string]
        $Protocol
    )

    switch ($PSBoundParameters) {
        { $_.ContainsKey('Endpoint') } { $env:OTEL_EXPORTER_OTLP_ENDPOINT = $Endpoint }
        { $_.ContainsKey('Headers') } { $env:OTEL_EXPORTER_OTLP_HEADERS = $Headers.Keys.ForEach({ "$_=$($Headers[$_])" }) -join ',' }
        { $_.ContainsKey('Timeout') } { $env:OTEL_EXPORTER_OTLP_TIMEOUT = $Timeout }
        { $_.ContainsKey('Protocol') } { $env:OTEL_EXPORTER_OTLP_PROTOCOL = $Protocol }
        Default {}
    }

    $type = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -like "*potel*lib*OpenTelemetry.Exporter.OpenTelemetryProtocol.dll" | Select-Object -Last 1

    switch ($PSBoundParameters) {
        { $_.ContainsKey('TracerProvider') } {
            $type.GetType('OpenTelemetry.Trace.OtlpTraceExporterHelperExtensions').GetMethod('AddOtlpExporter', ([System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::Static), [OpenTelemetry.Trace.TracerProviderBuilder]).Invoke($null, @($TracerProvider))
        }

        { $_.ContainsKey('MeterBuilder') } {
            $type.GetType('OpenTelemetry.Metrics.OtlpMetricExporterExtensions').GetMethod('AddOtlpExporter', ([System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::Static), [OpenTelemetry.Metrics.MeterProviderBuilder]).Invoke($null, @($MeterBuilder))
        }
    }
}