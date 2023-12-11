# Add-TracerSource



## Parameters

- `[String[]]` **Name**
  _no description_
- `[ActivitySource]` **ActivitySource**
  _no description_
- `[TracerProviderBuilderBase]` **TracerProviderBuilder**
  _no description_
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
