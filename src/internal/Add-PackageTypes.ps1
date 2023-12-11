function Add-PackageTypes {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LibsDirectory
    )

    begin {
        $plat = switch ([System.Environment]::OSVersion.Platform) {
            Win32NT { 'win'; break }
            Default { 'win' }
        }
        $bitness = switch ($true) {
            [System.Environment]::Is64BitProcess { 'x64'; break }
            Default { 'x64' }
        }

        $runtime = "$plat-$bitness"

        $target = Join-Path -Path $LibsDirectory -ChildPath $runtime
    }

    process {
        foreach ($path in (Get-ChildItem $target | Where-Object { $_.Name -like '*.dll' -and $_.BaseName -ne "grpc_csharp_ext.x64" } | Select-Object -ExpandProperty FullName)) {
            Add-Type -Path $path
        }
    }
}