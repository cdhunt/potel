function Add-ResourceConfiguration {
    <#
	.SYNOPSIS
		Adds a Resource Configuration to a Tracer
	.DESCRIPTION
		Adds a Resource Configuration to a Tracer. A resource represents the entity producing telemetry as resource attributes.
	.PARAMETER ServiceName
		An identifier usually base off of the name of the Service or Application generating the traces.
    .PARAMETER Attribute
        A key-value pair. Used across telemetry signals - e.g. in Traces to attach data to an Activity (Span)
    .PARAMETER TracerProvider
        A TracerProviderBuilderBase object
	.PARAMETER MeterBuilder
		Instance of MeterProviderBuilderBase
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ResourceConfiguration -ServiceName $ExecutionContext.Host.Name -Attribute @{"host.name" = $(hostname)} | Add-ExporterConsole | Start-Tracer
    .LINK
        https://opentelemetry.io/docs/instrumentation/net/resources/
	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ServiceName,

        [Parameter(Mandatory, Position = 1)]
        [hashtable]
        $Attribute,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Trace")]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Meter" )]
        [OpenTelemetry.Metrics.MeterProviderBuilderBase]
        $MeterBuilder
    )

    $listOfAttributes = [Collections.Generic.List[Collections.Generic.KeyValuePair[string, object]]]::new()

    Foreach ($key in $Attribute.Keys) {

        $listOfAttributes.Add([Collections.Generic.KeyValuePair[string, object]]::new($key, $Attribute[$key]))
    }

    $action = [Action[OpenTelemetry.Resources.ResourceBuilder]] {
        param([OpenTelemetry.Resources.ResourceBuilder]$resource)
        $resource = [OpenTelemetry.Resources.ResourceBuilderExtensions]::AddService($resource, $ServiceName)
        $resource = [OpenTelemetry.Resources.ResourceBuilderExtensions]::AddAttributes($resource, $listOfAttributes)
    }.GetNewClosure()

    switch ($PSBoundParameters) {
        { $_.ContainsKey('TracerProvider') } { [OpenTelemetry.Trace.TracerProviderBuilderExtensions]::ConfigureResource($TracerProvider, $action) }
        { $_.ContainsKey('MeterBuilder') } { [OpenTelemetry.Metrics.MeterProviderBuilderExtensions]::ConfigureResource($MeterBuilder, $action) }
        Default { Write-Warning "No parameter set" }
    }

}