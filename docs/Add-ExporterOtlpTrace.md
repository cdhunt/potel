# Add-ExporterOtlpTrace

Adds OpenTelemetry.Exporter.Console

## Parameters

### Parameter Set 1

- `[TracerProviderBuilderBase]` **TracerProvider** _Instance of TracerProviderBuilderBase._ Mandatory, ValueFromPipeline
- `[String]` **Endpoint** _OTLP endpoint address_ Mandatory
- `[Hashtable]` **Headers** _Headers to send_ 
- `[UInt32]` **Timeout** _Send timeout in ms_ 
- `[String]` **Protocol** _'grpc' or 'http/protobuf'_ 

### Parameter Set 2

- `[MeterProviderBuilderBase]` **MeterBuilder** _Instance of MeterProviderBuilderBase._ Mandatory, ValueFromPipeline
- `[String]` **Endpoint** _OTLP endpoint address_ Mandatory
- `[Hashtable]` **Headers** _Headers to send_ 
- `[UInt32]` **Timeout** _Send timeout in ms_ 
- `[String]` **Protocol** _'grpc' or 'http/protobuf'_ 

## Examples

### Example 1



```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ExporterOtlpTrace -Endpoint http://localhost:9999 | Start-Trace
```
### Example 2

Configure the Otlp Exporter for Honeycomb.

```powershell
Add-ExporterOtlpTrace  https://api.honeycomb.io:443 -Headers @{'x-honeycomb-team'='token'}
```
### Example 3

Configure the Otlp Exporter for Dynatrace.

```powershell
Add-ExporterOtlpTrace -Endpoint https://{your-environment-id}.live.dynatrace.com/api/v2/otlp -Headers @{'Authorization'='Api-Token dt.....'} -Protocol 'http/protobuf'
```

## Links

- [New-TracerProviderBuilder](New-TracerProviderBuilder.md)
- [Add-HttpClientInstrumentation](Add-HttpClientInstrumentation.md)
- [Start-Tracer](Start-Tracer.md)
- [https://docs.honeycomb.io/getting-data-in/opentelemetry-overview/#using-the-honeycomb-opentelemetry-endpoint](https://docs.honeycomb.io/getting-data-in/opentelemetry-overview/#using-the-honeycomb-opentelemetry-endpoint)
- [https://docs.dynatrace.com/docs/extend-dynatrace/opentelemetry/getting-started/otlp-export](https://docs.dynatrace.com/docs/extend-dynatrace/opentelemetry/getting-started/otlp-export)

## Outputs

- `TracerProviderBuilderBase`
