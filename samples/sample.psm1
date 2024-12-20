<#
docker run --rm --name jaeger `
  -p 16686:16686 `
  -p 4317:4317 `
  -p 4318:4318 `
  -p 5778:5778 `
  -p 9411:9411 `
  jaegertracing/jaeger:2.1.0
 #>
$activitySource = New-ActivitySource -Name potel-sample

New-TracerProviderBuilder |
Add-TracerSource -ActivitySource $activitySource |
Add-ResourceConfiguration -ServiceName potel-sample -Attribute @{"host.name" = 'chunt' } |
Add-HttpClientInstrumentation |
Add-ExporterOtlpTrace -Endpoint http://localhost:4317 |
Add-ExporterConsole |
Start-Tracer

function Get-SampleSomething {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [int]
        $SecondsToWait
    )

    $activity = $activitySource | Start-Activity -Name "Get-SampleSomething"

    $activity | Add-ActivityTag @{'SecondsToWait' = $SecondsToWait }

    $activity | Add-ActivityEvent -Message "About to go to sleep"

    Start-Sleep -Seconds $SecondsToWait

    $activity | Add-ActivityEvent -Message "Finished sleeping"

    Get-Google

    $activity.Stop()
}

function Get-Google {
    [CmdletBinding()]
    param (

    )

    $activity = $activitySource | Start-Activity -Name "Get-Google"

    Invoke-WebRequest -Uri https://google.com | Out-Null

    $activity.Stop()

}