# Add-HttpClientInstrumentation

Adds Http Client Instrumentation

## Parameters

### Parameter Set 1

- `[TracerProviderBuilderBase]` **TracerProvider** _Instance of TracerProviderBuilderBase._ Mandatory, ValueFromPipeline

## Examples

### Example 1



```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation
```

## Links

- [New-TracerProviderBuilder](New-TracerProviderBuilder.md)
- [https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md)

## Outputs

- `TracerProviderBuilderBase`
