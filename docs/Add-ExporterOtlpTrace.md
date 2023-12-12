# Add-ExporterOtlpTrace


Adds OpenTelemetry.Exporter.Console
## Parameters


### Parameter Set 1


- `[TracerProviderBuilderBase]` **TracerProvider** _Instance of TracerProviderBuilderBase_.  Mandatory, ValueFromPipeline
- `[String]` **Endpoint** _OTLP endpoint address_.  Mandatory
- `[Hashtable]` **Headers** _Headers to send_.  
- `[UInt32]` **Timeout** _Send timeout in ms_.  
- `[String]` **Protocol** _'grpc' or 'http/protobuf'_.  


### Parameter Set 2


- `[MeterProviderBuilderBase]` **MeterBuilder** _Instance of MeterProviderBuilderBase_.  Mandatory, ValueFromPipeline
- `[String]` **Endpoint** _OTLP endpoint address_.  Mandatory
- `[Hashtable]` **Headers** _Headers to send_.  
- `[UInt32]` **Timeout** _Send timeout in ms_.  
- `[String]` **Protocol** _'grpc' or 'http/protobuf'_.  


## Examples


### Example 1




```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ExporterOtlpTrace | Start-Trace
```


## Links


- [New-TracerProviderBuilder](New-TracerProviderBuilder.md)
- [Add-HttpClientInstrumentation](Add-HttpClientInstrumentation.md)
- [Start-Tracer](Start-Tracer.md)
