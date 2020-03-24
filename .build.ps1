task Build @(
    'Setup'
    'Clean'
    'CreatePackage'
    'UpdateLocal'
)

task Setup {
    $Global:buildInfo = [PSCustomObject]@{
        Name            = $name = 'Rimsenal Security - Turret Extensions Patch (continued)'
        PublishedFileID = ''
        Path            = [PSCustomObject]@{
            Mod   = Join-Path -Path $psscriptroot -ChildPath $name
            Build = Join-Path -Path $psscriptroot -ChildPath 'build'
        }
    }
}

task Clean {
    if (Test-Path $buildInfo.Path.Build) {
        Remove-Item $buildInfo.Path.Build -Recurse
    }
    New-Item $buildInfo.Path.Build -ItemType Directory
}

task CreatePackage {
    $params = @{
        Path            = $buildInfo.Path.Mod
        DestinationPath = Join-Path $buildInfo.Path.Build ('{0}.zip' -f $buildInfo.Name)
    }
    Compress-Archive @params
}

task UpdateLocal {
    $path = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 294100' -Name 'InstallLocation').InstallLocation
    $modPath = [System.IO.Path]::Combine($path, 'Mods', $buildInfo.Name)

    if (Test-Path $modPath) {
        Remove-Item $modPath -Recurse
    }

    Copy-Item -Path $buildInfo.Path.Mod -Destination "$path\Mods" -Recurse -Force
}
