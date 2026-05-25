#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Packages = @(
    # Optional, uncomment to include:
    @{ Id = 'ls-kds-service'; Version = '!^' }
    @{ Id = 'ls-kds-display-station-windows'; Version = '!^' }
    @{ Id = 'ls-hardware-station'; Version = '!^' }
    @{ Id = 'ls-central-appshell'; Version = '!^' }
    @{ Id = 'ls-kds-service-web'; Version = '!^' }
)

$Packages | Install-UscPackage