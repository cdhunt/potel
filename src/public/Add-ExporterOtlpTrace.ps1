function Add-ExporterOtlpTrace {
    <#
	.SYNOPSIS
		Adds an OTLP Exporter
	.DESCRIPTION
		Adds OpenTelemetry.Exporter.Console
	.PARAMETER TracerProvider
		Instance of TracerProviderBuilderBase.
	.PARAMETER MeterBuilder
		Instance of MeterProviderBuilderBase.
    .PARAMETER Endpoint
        OTLP endpoint address
    .PARAMETER Headers
        Headers to send
    .PARAMETER Timeout
        Send timeout in ms
    .PARAMETER Protocol
        'grpc' or 'http/protobuf'
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ExporterOtlpTrace -Endpoint http://localhost:9999 | Start-Trace
    .EXAMPLE
        Add-ExporterOtlpTrace  https://api.honeycomb.io:443 -Headers @{'x-honeycomb-team'='token'}

        Configure the Otlp Exporter for Honeycomb.
    .EXAMPLE
        Add-ExporterOtlpTrace -Endpoint https://{your-environment-id}.live.dynatrace.com/api/v2/otlp -Headers @{'Authorization'='Api-Token dt.....'} -Protocol 'http/protobuf'

        Configure the Otlp Exporter for Dynatrace.
    .LINK
        New-TracerProviderBuilder
    .LINK
        Add-HttpClientInstrumentation
    .LINK
        Start-Tracer
    .LINK
        https://docs.honeycomb.io/getting-data-in/opentelemetry-overview/#using-the-honeycomb-opentelemetry-endpoint
    .LINK
        https://docs.dynatrace.com/docs/extend-dynatrace/opentelemetry/getting-started/otlp-export
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