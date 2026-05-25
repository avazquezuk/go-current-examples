#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        #ConnectionString = $ConnectionString
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/${Package.InstanceName}'
        NoDatabaseUpgrades = 'False'
    }
    'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    @{ Id = 'ls-central-demo-database'; Version = '!^ 24.0' }
    @{ Id = 'bc-web-client'; Version = '!^ 24.0' }
    @{ Id = 'bc-system-application-runtime'; Version = '!^ 24.0' }
    @{ Id = 'bc-base-application-runtime'; Version = '!^ 24.0' }
    @{ Id = 'ls-central-app'; Version = '!^ 24.0' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'ls-kds-service'; Version = '!^ 24.0' }
    @{ Id = 'ls-kds-display-station-windows'; Version = '!^ 24.0' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 24.0' }
)

$Packages | Install-UscPackage -InstanceName 'Scandlines-SSK-v24' -Arguments $Arguments -UpdateInstance