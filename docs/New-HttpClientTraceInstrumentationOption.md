# New-HttpClientTraceInstrumentationOption

Initializes a new instance of the HttpClientTraceInstrumentationOptions class for HttpClient instrumentation.

## Parameters

### Parameter Set 1

- `[Func[Net.Http.HttpRequestMessage, bool]]` **RequestFilter** _A filter function that determines whether or not to collect telemetry on a per request basis._
- `[Switch]` **RecordException** _Indicating whether exception will be recorded ActivityEvent or not. This instrumentation automatically sets Activity Status to Error if the Http StatusCode is >= 400. Additionally, `RecordException` feature may be turned on, to store the exception to the Activity itself as ActivityEvent._

## Examples

### Example 1

Collect only web requests with a `Method` of `Get`.

```powershell
$options = New-HttpClientTraceInstrumentationOption -RequestFilter {param([Net.Http.HttpRequestMessage]$request) $request.Method -eq 'Get' }
New-TracerProviderBuilder | Add-HttpClientInstrumentation -Options $options
```

### Example 2

Collect only web requests send to the "google.com" domain.

```powershell
$options = New-HttpClientTraceInstrumentationOption -RequestFilter {param([Net.Http.HttpRequestMessage]$request) $request.RequestUri -like '*google.com*' }
New-TracerProviderBuilder | Add-HttpClientInstrumentation -Options $options
```

## Links

- [https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=netstandard-2.1#properties)

## Notes

Filter scriptblock must return a bool. `[Func[Net.Http.HttpRequestMessage, bool]]`

## Outputs

- `OpenTelemetry.Instrumentation.Http.HttpClientTraceInstrumentationOptions`
