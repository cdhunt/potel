#! /usr/bin/pwsh

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateSet('clean', 'build', 'test', 'changes', 'publish', 'docs')]
    [string[]]
    $Task,

    [Parameter(Position = 1)]
    [int]
    $Revision = 0,

    [Parameter(Position = 2)]
    [int]
    $Build = 0,

    [Parameter(Position = 3)]
    [int]
    $Minor = 1,

    [Parameter(Position = 4)]
    [int]
    $Major = 0,

    [Parameter(Position = 5)]
    [string]
    $Prerelease
)

$parent = $PSScriptRoot
$parent = [string]::IsNullOrEmpty($parent) ? $pwd.Path : $parent
$src = Join-Path $parent -ChildPath "src"
$docs = Join-Path $parent -ChildPath "docs"
$publish = Join-Path $parent -ChildPath "publish" -AdditionalChildPath 'potel'
$csproj = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "potel.csproj"
$bin = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "bin"
$obj = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "obj"
$lib = Join-Path -Path $publish -ChildPath "lib"
$libwin64 = Join-Path -Path $lib -ChildPath "win-x64"
$liblin64 = Join-Path -Path $lib -ChildPath "linux-x64"

Write-Host "src: $src"
Write-Host "docs: $docs"
Write-Host "publish: $publish"
Write-Host "lib: $lib"
Write-Host "dotnet: $([Environment]::Version)"
Write-Host "ps: $($PSVersionTable.PSVersion)"

$manifest = @{
    Path                  = Join-Path -Path $publish -ChildPath 'potel.psd1'
    Author                = 'Chris Hunt'
    CompanyName           = 'Chris Hunt'
    Copyright             = 'Chris Hunt'
    CompatiblePSEditions  = "Core"
    Description           = 'PowerShell module for collecting and sending Open Telemetry'
    LicenseUri            = 'https://github.com/cdhunt/potel/blob/main/LICENSE'
    FunctionsToExport     = @()
    ModuleVersion         = [version]::new($Major, $Minor, $Build, $Revision)
    ProcessorArchitecture = 'Amd64'
    PowerShellVersion     = '7.3'
    ProjectUri            = 'https://github.com/cdhunt/potel'
    RootModule            = 'potel.psm1'
    Tags                  = @('otel', 'distributed tracing', 'metrics', 'telemetry')
}

function Clean {
    param ()

    if (Test-Path $publish) {
        Remove-Item -Path $publish -Recurse -Force
    }
}

function Build {
    param ()

    New-Item -Path $publish -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

    dotnet publish $csproj --runtime win-x64 -o $libwin64
    dotnet publish $csproj --runtime linux-x64 -o $liblin64

    @($libwin64, $liblin64) | ForEach-Object {
        Get-ChildItem -Path $_ -filter "*.json" | Remove-Item -Force -ErrorAction SilentlyContinue
        Get-ChildItem -Path $_ -filter "*.pdb" | Remove-Item -Force -ErrorAction SilentlyContinue
        Get-ChildItem -Path $_ -filter "System.Management.Automation.dll" | Remove-Item -Force -ErrorAction SilentlyContinue
        Get-ChildItem -Path $_ -filter "potel.dll" | Remove-Item -Force -ErrorAction SilentlyContinue
    }

    Copy-Item -Path "$src/potel.psm1" -Destination $publish
    Copy-Item -Path @("$parent/LICENSE", "$parent/README.md") -Destination $publish

    $internalFunctions = Get-ChildItem -Path "$src/internal/*.ps1"
    $publicFunctions = Get-ChildItem -Path "$src/public/*.ps1"
    $privateFunctions = Get-ChildItem -Path "$src/private/*.ps1" -ErrorAction SilentlyContinue

    New-Item -Path "$publish/internal" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    foreach ($function in $internalFunctions) {
        Copy-Item -Path $function.FullName -Destination "$publish/internal/$($function.Name)"
    }

    New-Item -Path "$publish/public" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    foreach ($function in $publicFunctions) {
        Copy-Item -Path $function.FullName -Destination "$publish/public/$($function.Name)"
        '. "$PSSCriptRoot/public/{0}"' -f $function.Name | Add-Content "$publish/potel.psm1"
        $manifest.FunctionsToExport += $function.BaseName
    }

    New-Item -Path "$publish/private" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    foreach ($function in $privateFunctions) {
        Copy-Item -Path $function.FullName -Destination "$publish/private/$($function.Name)"
        '. "$PSSCriptRoot/private/{0}"' -f $function.Name | Add-Content "$publish/potel.psm1"
    }

    if ($PSBoundParameters.ContainsKey('Prerelease')) {
        $manifest.Add('Prerelease', $PreRelease)
    }

    New-ModuleManifest @manifest
}

function Test {
    param ()

    if ($null -eq (Get-Module Pester -ListAvailable)) {
        Install-Module -Name Pester -Confirm:$false -Force
    }

    Invoke-Pester -Path test
}

function Changes {
    param ()

    git log -n 3 --pretty='format:%h %s'
}

function Commit {
    param ()

    git rev-parse --short HEAD
}

function Publish {
    param ()

    $repo = if ($env:PSPublishRepo) { $env:PSPublishRepo } else { 'PSGallery' }

    #$notes = Changes
    $notes = "Initial Publish"
    Publish-Module -Path $publish -Repository $repo -NuGetApiKey $env:PSPublishApiKey -ReleaseNotes $notes
}

function Docs {
    param ()

    Import-Module $publish -Force

    $commands = Get-Command -Module potel

    @"
# Potel

$($manifest.Description)

## Cmdlets

"@ | Set-Content -Path "$docs/README.md"

    foreach ($command in $Commands | Sort-Object -Property Verb) {
        $name = $command.Name
        $docPath = Join-Path -Path $docs -ChildPath "$name.md"
        $help = Get-Help -Name $name

        @"
# $($command.Name)

$($command.Description)

## Parameters

"@ | Set-Content -Path $docPath

        foreach ($parameterSet in $help.parameters) {
            foreach ($parameterList in $parameterSet.parameter) {
                foreach ($parameter in $parameterList | Sort-Object -Property position) {

                    "- [$($parameter.type.name)] $($parameter.name)" | Add-Content -Path $docPath
                    "  $($parameter.description.Text)" | Add-Content -Path $docPath
                }
            }
        }

        $count = 0
        @'
## Examples

'@ | Add-Content -Path $docPath
        foreach ($exampleList in $help.examples.example) {
            $count++
            foreach ($example in $exampleList) {
                "### Example $count" | Add-Content -Path $docPath

                $($example.remarks.Text.Where({ ![string]::IsNullOrEmpty($_) })) | Add-Content -Path $docPath
                @"

``````powershell
$($example.code.Trim("`t"))
``````
"@ | Add-Content -Path $docPath

            }
        }

        if ($help.relatedLinks.count -gt 0) {
            @'
## Links

'@ | Add-Content -Path $docPath

            foreach ($link in $help.relatedLinks) {
                $uri = $link.navigationLink.uri
                "- [$uri]($uri)" | Add-Content -Path $docPath
            }
        }

        "- [$name]($name.md) $($help.Synopsis)" | Add-Content -Path "$docs/README.md"
    }
}

switch ($Task) {
    { $_ -contains 'clean' } {
        Clean
    }
    { $_ -contains 'build' } {
        Clean
        Build
    }
    { $_ -contains 'test' } {
        Test
    }
    { $_ -contains 'changes' } {
        Changes
    }
    { $_ -contains 'publish' } {
        Publish
    }
    { $_ -contains 'docs' } {
        Docs
    }
    Default {
        Clean
        Build
    }
}