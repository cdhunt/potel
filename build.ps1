[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateSet('clean', 'build', 'test', 'changes', 'publish')]
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
$publish = Join-Path $parent -ChildPath "publish" -AdditionalChildPath 'potel'
$csproj = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "potel.csproj"
$bin = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "bin"
$obj = Join-Path -Path $src -ChildPath "dotnet" -AdditionalChildPath "obj"
$lib = Join-Path -Path $publish -ChildPath "lib"

$manifest = @{
    Path                  = Join-Path -Path $publish -ChildPath 'potel.psd1'
    Author                = 'Chris Hunt'
    CompanyName           = 'Chris Hunt'
    Copyright             = 'Chris Hunt'
    CompatiblePSEditions  = "Core"
    LicenseUri            = 'https://github.com/cdhunt/potel/blob/main/LICENSE'
    FunctionsToExport     = @()
    ModuleVersion         = [version]::new($Major, $Minor, $Build, $Revision)
    ProcessorArchitecture = 'Amd64'
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

    dotnet publish $csproj --runtime win-x64 -o $lib

    Get-ChildItem -Path $lib -filter "*.json" | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path $lib -filter "*.pdb" | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path $lib -filter "System.Management.Automation.dll" | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path $lib -filter "potel.dll" | Remove-Item -Force -ErrorAction SilentlyContinue
    Remove-Item -Path @($bin, $obj) -Recurse -Force

    Copy-Item -Path "$src/potel.psm1" -Destination $publish
    Copy-Item -Path @("$parent/LICENSE", "$parent/README.md") -Destination $publish

    $internalFunctions = Get-ChildItem -Path "$src/internal/*.ps1"
    $publicFunctions = Get-ChildItem -Path "$src/public/*.ps1"
    $privateFunctions = Get-ChildItem -Path "$src/private/*.ps1"

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

    $notes = Changes
    Publish-Module -Path $publish -Repository $repo -NuGetApiKey $env:PSPublishApiKey -ReleaseNotes $notes
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
    Default {
        Clean
        Build
    }
}