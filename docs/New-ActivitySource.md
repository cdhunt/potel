# New-ActivitySource

Create an instance of ActivitySource. ActivitySource provides APIs to create and start Activity objects.

## Parameters

### Parameter Set 1

- `[String]` **Name** _The Source Name. The source name passed to the constructor has to be unique to avoid the conflicts with any other sources._ Mandatory
- `[String]` **Version** _The version parameter is optional._ 

## Links

- [Start-Activity](Start-Activity.md)
- [https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs#activitysource](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs#activitysource)

## Notes

ActivitySource is the .Net implementation of an OpenTelemetry "Tracer"

## Outputs

- `System.Diagnostics.ActivitySource`
