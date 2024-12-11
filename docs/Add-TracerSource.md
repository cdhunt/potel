# Add-TracerSource

Adds and ActivitySource to a TracerProviderBuilder

## Parameters

### Parameter Set 1

- `[String[]]` **Name** _Name of the Activity_ Mandatory
- `[TracerProviderBuilderBase]` **TracerProviderBuilder** _A TracerProviderBuilderBase object_ Mandatory, ValueFromPipeline

### Parameter Set 2

- `[ActivitySource]` **ActivitySource** _An ActivitySource object_ Mandatory
- `[TracerProviderBuilderBase]` **TracerProviderBuilder** _A TracerProviderBuilderBase object_ Mandatory, ValueFromPipeline

## Examples

### Example 1

Add a source by Name.

```powershell
New-TracerProviderBuilder | Add-TracerSource -Name "MyActivity"
```
### Example 2

Create an Activity Soruce object.

```powershell
$source = New-ActivitySource -Name "MyActivity"
New-TracerProviderBuilder | Add-TracerSource -AcvititySource $source
```

## Links

- [New-TracerProviderBuilder](New-TracerProviderBuilder.md)
- [New-ActivitySource](New-ActivitySource.md)
- [https://opentelemetry.io/docs/instrumentation/net/manual/#setting-up-an-activitysource](https://opentelemetry.io/docs/instrumentation/net/manual/#setting-up-an-activitysource)

## Outputs

- `TracerProviderBuilderBase`
