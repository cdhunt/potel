# Set-ActivityStatus

OpenTelemetry allows each Activity to report a Status that represents the pass/fail result of the work.

## Parameters

### Parameter Set 1

- `[Switch]` **StatusCode** _An ActivityStatusCode. The ActivityStatusCode values are represented as either, `Unset`, `Ok`, and `Error`._ Mandatory
- `[String]` **Description** _Optional Description that provides a descriptive message of the Status. `Description` **MUST** only be used with the `Error` `StatusCode` value._ 
- `[Activity]` **Activity** _Parameter help description_ Mandatory, ValueFromPipeline

## Links

- [Start-Activity](Start-Activity.md)

## Notes

StatusCode is one of the following values:
- Unset: The default status.
- Ok: The operation has been validated by an Application developer or Operator to have completed successfully.
- Error: The operation contains an error.
