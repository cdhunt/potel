# Add-ExporterOtlpTrace



## Parameters

- `[TracerProviderBuilderBase]` **TracerProvider**
  _no description_
- `[MeterProviderBuilderBase]` **MeterBuilder**
  _no description_
- `[String]` **Endpoint**
  _no description_
- `[Hashtable]` **Headers**
  _no description_
- `[UInt32]` **Timeout**
  _no description_
- `[String]` **Protocol**
  _no description_
## Examples

### Example 1

```powershell
New-TracerBuilder | Add-HttpClientInstrumentation
```
