# New-TracerProviderBuilder

Creates instance of OpenTelemetry.Sdk TracerProviderBuilder

## Parameters

- `[String]`  **ActivityName**
 _no description_
- `[ActivitySource]`  **ActivitySource**
 _no description_
## Examples

### Example 1

```powershell
New-TracerProviderBuilder
```
### Example 2

```powershell
New-TracerProviderBuilder -ActivyName "MyActivity"
```
## Links

- [Add-TracerSource](Add-TracerSource.md)
- [Start-Tracer](Start-Tracer.md)
- [Stop-Tracer](Stop-Tracer.md)
- [https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry/Sdk.cs](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry/Sdk.cs)
