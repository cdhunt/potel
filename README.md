# potel
PowerShell module for collecting and sending Open Telemetry

## CI Status

[![PowerShell](https://github.com/cdhunt/potel/actions/workflows/powershell.yml/badge.svg)](https://github.com/cdhunt/potel/actions/workflows/powershell.yml)

## Install

[powershellgallery.com/packages/potel](https://www.powershellgallery.com/packages/potel)

`Install-Module -Name potel` or `Install-PSResource -Name potel`

## Docs

[Full Docs](docs)

### Getting Started

Auto-instrument `HttpClient` calls within the current PowerShell session and send traces to [HoneyComb.io](https://honeycomb.io) and the console.

```powershell
New-TracerProviderBuilder |
    Add-TracerSource -Name "potel" |
    Add-HttpClientInstrumentation |
    Add-ExporterOtlpTrace -Endpoint https://api.honeycomb.io:443 -Headers @{'x-honeycomb-team'='abc123'} |
    Add-ExporterConsole |
    Start-Tracer
```
