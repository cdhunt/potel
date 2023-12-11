function Add-HttpClientInstrumentation {
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
		PS> New-TracerBuilder | Add-HttpClientInstrumentation
	#>
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $InputObject
    )

    $type = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -like "*potel*lib*OpenTelemetry.Instrumentation.Http.dll" | Select-Object -Last 1

    $type.GetType('OpenTelemetry.Trace.TracerProviderBuilderExtensions').GetMethod('AddHttpClientInstrumentation', ([System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::Static), [OpenTelemetry.Trace.TracerProviderBuilder]).Invoke($null, @($InputObject))
}