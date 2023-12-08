# Add-TracerSource



## Parameters

- [String[]] Name
  
- [ActivitySource] ActivitySource
  
- [TracerProviderBuilderBase] TracerProviderBuilder
  
## Examples

### Example 1
Adds a source by given name value.

```powershell
New-TracerProviderBuilder | Add-TracerSource -Name "MyActivity"
```
### Example 2
Adds a source from an ActivitySource object.

```powershell
$source = New-ActivitySource -Name "MyActivity"
      PS> New-TracerProviderBuilder | Add-TracerSource -AcvititySource $source
```
