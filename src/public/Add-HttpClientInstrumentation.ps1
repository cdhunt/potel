function Add-HttpClientInstrumentation {
    <#
	.SYNOPSIS
		Adds Http Client Instrumentation
	.DESCRIPTION
		Adds Http Client Instrumentation
	.PARAMETER TracerProvider
		Instance of TracerProviderBuilderBase.
	.INPUTS
		Instance of TracerProviderBuilderBase
	.OUTPUTS
		TracerProviderBuilderBase
	.EXAMPLE
		New-TracerProviderBuilder | Add-HttpClientInstrumentation
	.LINK
		New-TracerProviderBuilder
	#>
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [OpenTelemetry.Trace.TracerProviderBuilderBase]
        $TracerProvider
    )

    $type = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -like "*potel*lib*OpenTelemetry.Instrumentation.Http.dll" | Select-Object -Last 1

    $type.GetType('OpenTelemetry.Trace.TracerProviderBuilderExtensions').GetMethod('AddHttpClientInstrumentation', ([System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::Static), [OpenTelemetry.Trace.TracerProviderBuilder]).Invoke($null, @($TracerProvider))
}