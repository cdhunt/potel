# New-TracerProviderBuilder

Creates instance of OpenTelemetry.Sdk TracerProviderBuilder

## Parameters

### Parameter Set 1

- `[String]` **ActivityName** _Parameter help description_ 

### Parameter Set 2

- `[ActivitySource]` **ActivitySource** _Parameter help description_ 

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

- [https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry/Sdk.cs](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry/Sdk.cs)
- [Add-TracerSource](Add-TracerSource.md)
- [Start-Tracer](Start-Tracer.md)
- [Stop-Tracer](Stop-Tracer.md)

## Outputs

- `TracerProviderBuilder`
