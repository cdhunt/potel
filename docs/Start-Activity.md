# Start-Activity

Start an Activity.

## Parameters

### Parameter Set 1

- `[String]` **Name** _The name of the activity._ Mandatory
- `[Switch]` **Kind** _An Activity.Kind for this Activity.
  - Internal: Internal operation within an application, as opposed to operations with remote parents or children. This is the default value.
  - Server: Requests incoming from external component
  - Client: Outgoing request to the external component
  - Producer: Output provided to external components
  - Consumer: Output received from an external component_ 
- `[ActivitySource]` **ActivitySource** _An ActivitySource._ Mandatory, ValueFromPipeline

## Links

- [New-ActivitySource](New-ActivitySource.md)
- [https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-instrumentation-walkthroughs)

## Notes

Activity is the .Net implementation of an OpenTelemetry "Span".
If there are no registered listeners or there are listeners that are not interested, Start-Activity
will return null and avoid creating the Activity object. This is a performance optimization so that
the code pattern can still be used in functions that are called frequently.

## Outputs

- `System.Diagnostics.Activity`
