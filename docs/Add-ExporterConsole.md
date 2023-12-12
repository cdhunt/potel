# Add-ExporterConsole

Adds OpenTelemetry.Exporter.Console

## Parameters

- `[TracerProviderBuilderBase]` (pipeline: true (ByValue)) **TracerProvider**
 _Parameter help description_
- `[MeterProviderBuilderBase]` (pipeline: true (ByValue)) **MeterBuilder**
 _no description_
## Examples

### Example 1

```powershell
New-TracerBuilder | Add-HttpClientInstrumentation
```
## Links

- [Add-HttpClientInstrumentation](Add-HttpClientInstrumentation.md)
