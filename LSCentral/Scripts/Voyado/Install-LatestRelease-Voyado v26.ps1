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
    @{ Id = 'ls-central-demo-database'; Version = '!^ 26.1' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app'; Version = '!^ 26.1' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 26.1' }
)

$Packages | Install-UscPackage -InstanceName 'OnPrem-Voyado-v261' -Arguments $Arguments -UpdateInstance