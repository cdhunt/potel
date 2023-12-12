# Add-ExporterOtlpTrace

Adds OpenTelemetry.Exporter.Console

## Parameters

- `[TracerProviderBuilderBase]` (pipeline: true (ByValue)) **TracerProvider**
 _no description_
- `[MeterProviderBuilderBase]` (pipeline: true (ByValue)) **MeterBuilder**
 _no description_
- `[String]`  **Endpoint**
 _no description_
- `[Hashtable]`  **Headers**
 _no description_
- `[UInt32]`  **Timeout**
 _no description_
- `[String]`  **Protocol**
 _no description_
## Examples

### Example 1

```powershell
New-TracerBuilder | Add-HttpClientInstrumentation
```
## Links

- [Add-HttpClientInstrumentation](Add-HttpClientInstrumentation)
