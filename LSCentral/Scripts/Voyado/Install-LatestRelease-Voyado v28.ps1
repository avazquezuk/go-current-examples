#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        AllowForceSync = 'true'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/${Package.InstanceName}'
    }
        'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    @{ Id = 'ls-central-demo-database'; Version = '!^ 28.0' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app'; Version = '!^ 28.0' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 28.0' }
)

$Packages | Install-UscPackage -InstanceName 'OnPrem-Voyado-v28' -Arguments $Arguments -UpdateInstance