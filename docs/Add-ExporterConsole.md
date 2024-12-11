# Add-ExporterConsole

Adds OpenTelemetry.Exporter.Console

## Parameters

### Parameter Set 1

- `[TracerProviderBuilderBase]` **TracerProvider** _Instance of TracerProviderBuilderBase._ Mandatory, ValueFromPipeline

### Parameter Set 2

- `[MeterProviderBuilderBase]` **MeterBuilder** _Instance of MeterProviderBuilderBase._ Mandatory, ValueFromPipeline

## Examples

### Example 1



```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ExporterConsole | Start-Trace
```

## Links

- [Add-HttpClientInstrumentation](Add-HttpClientInstrumentation.md)
- [Start-Tracer](Start-Tracer.md)

## Outputs

- `TracerProviderBuilderBase`
