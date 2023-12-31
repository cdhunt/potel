#! /usr/bin/pwsh

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateSet('clean', 'build', 'test', 'changelog', 'publish', 'docs')]
    [string[]]
    $Task,

    [Parameter(Position = 1)]
    [int]
    $Major,

    [Parameter(Position = 2)]
    [int]
    $Minor,

    [Parameter(Position = 3)]
    [int]
    $Build,

    [Parameter(Position = 4)]
    [int]
    $Revision,

    [Parameter(Position = 5)]
    [string]
    $Prerelease
)

if ( (Get-Command 'nbgv' -CommandType Application -ErrorAction SilentlyContinue) ) {
    if (!$PSBoundParameters.ContainsKey('Major')) { $Major = $(nbgv get-version -v VersionMajor) }
    if (!$PSBoundParameters.ContainsKey('Minor')) { $Minor = $(nbgv get-version -v VersionMinor) }
    if (!$PSBoundParameters.ContainsKey('Build')) { $Build = $(nbgv get-version -v BuildNumber) }
    if (!$PSBoundParameters.ContainsKey('Revision')) { $Revision = $(nbgv get-version -v VersionRevision) }
}

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
    Tags                  = @('otel', 'distributed-tracing', 'metrics', 'telemetry', 'diagnostics')
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

function ChangeLog {
    param ()

    "# Changelog"

    # Start log at >0.1.11
    for ($m = $Minor; $m -ge 1; $m--) {
        for ($b = $Build; $b -gt 11; $b--) {
            "## v$Major.$m.$b"
            nbgv get-commits "$Major.$m.$b" | ForEach-Object {
                $hash, $ver, $message = $_.split(' ')
                $shortHash = $hash.Substring(0, 7)

                "- [$shortHash](https://github.com/cdhunt/potel/commit/$hash) $($message -join ' ')"
            }
        }
    }
}

function Commit {
    param ()

    git rev-parse --short HEAD
}

function Publish {
    param ()

    <# Disabled for now
    $docChanges = git status docs -s

    if ($docChanges.count -gt 0) {
        Write-Warning "There are pending Docs change. Run './build.ps1 docs', review and commit updated docs."
    }
    #>

    $repo = if ($env:PSPublishRepo) { $env:PSPublishRepo } else { 'PSGallery' }

    $notes = ChangeLog
    Publish-Module -Path $publish -Repository $repo -NuGetApiKey $env:PSPublishApiKey -ReleaseNotes $notes
}

function Docs {
    param ()

    Import-Module $publish -Force

    $commands = Get-Command -Module potel
    $HelpToMd = Join-Path -Path $src -ChildPath 'internal' -AdditionalChildPath 'Export-HelpToMd.ps1'
    . $HelpToMd

    @('# Potel', [System.Environment]::NewLine) | Set-Content -Path "$docs/README.md"
    $($manifest.Description) | Add-Content -Path "$docs/README.md"
    @('## Cmdlets', [System.Environment]::NewLine) | Add-Content -Path "$docs/README.md"

    foreach ($command in $Commands | Sort-Object -Property Verb) {
        $name = $command.Name
        $docPath = Join-Path -Path $docs -ChildPath "$name.md"
        $help = Get-Help -Name $name

        Export-HelpToMd $help | Set-Content -Path $docPath

        "- [$name]($name.md) $($help.Synopsis)" | Add-Content -Path "$docs/README.md"
    }

    ChangeLog | Set-Content -Path "$parent/Changelog.md"
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
    { $_ -contains 'changelog' } {
        ChangeLog
    }
    { $_ -contains 'publish' } {
        Docs
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