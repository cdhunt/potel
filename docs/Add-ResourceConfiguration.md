# Add-ResourceConfiguration


Adds a Resource Configuration to a Tracer. A resource represents the entity producing telemetry as resource attributes
## Parameters


### Parameter Set 1


- `[String]` **ServiceName** _An identifier usually base off of the name of the Service or Application generating the traces_.  Mandatory
- `[Hashtable]` **Attribute** _A key-value pair. Used across telemetry signals - e.g. in Traces to attach data to an Activity (Span)_.  Mandatory
- `[TracerProviderBuilderBase]` **TracerProvider** _A TracerProviderBuilderBase object_.  Mandatory, ValueFromPipeline


### Parameter Set 2


- `[String]` **ServiceName** _An identifier usually base off of the name of the Service or Application generating the traces_.  Mandatory
- `[Hashtable]` **Attribute** _A key-value pair. Used across telemetry signals - e.g. in Traces to attach data to an Activity (Span)_.  Mandatory
- `[MeterProviderBuilderBase]` **MeterBuilder** _Instance of MeterProviderBuilderBase_.  Mandatory, ValueFromPipeline


## Examples


### Example 1




```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation | Add-ResourceConfiguration -ServiceName $ExecutionContext.Host.Name -Attribute @{"host.name" = $(hostname)} | Add-ExporterConsole | Start-Tracer
```


## Links


- [https://opentelemetry.io/docs/instrumentation/net/resources/](https://opentelemetry.io/docs/instrumentation/net/resources/)
