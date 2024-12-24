# Add-HttpClientInstrumentation

Adds Http Client Instrumentation.

## Parameters

### Parameter Set 1

- `[TracerProviderBuilderBase]` **TracerProvider** _Instance of TracerProviderBuilderBase._ Mandatory, ValueFromPipeline
- `[ScriptBlock]` **RequestFilter** _A filter function that determines whether or not to collect telemetry on a per request basis. Must return a bool._ 
- `[Switch]` **RecordException** _Indicating whether exception will be recorded ActivityEvent or not. This instrumentation automatically sets Activity Status to Error if the Http StatusCode is >= 400. Additionally, `RecordException` feature may be turned on, to store the exception to the Activity itself as ActivityEvent._ 

## Examples

### Example 1

Enabled the zero-code instrumentation of System.Net.Http.HttpClient methods.

```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation
```
### Example 2

Only collect web requests with a `Method` of `Get`.

```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation { $_.Method -eq 'Get' }
```
### Example 3

Only collect web requests sent to the "google.com" domain.

```powershell
New-TracerProviderBuilder | Add-HttpClientInstrumentation  { $_.RequestUri -like '*google.com*' }
```

## Links

- [New-TracerProviderBuilder](New-TracerProviderBuilder.md)
- [https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.Http/README.md)
- [https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties)

## Outputs

- `TracerProviderBuilderBase`
