#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        DeveloperServicesEnabled = 'true'
        AllowForceSync = 'true'
        ClientServicesCredentialType = 'NavUserPassword'
        ServicesCertificateThumbprint = 'e4e910349c5dedf93b257b1b5bfc310b16efad07'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=OnPrem-Voyado-v261;Integrated Security=True'
    }
}

$Packages = @(
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 26.1' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 26.1' }
)

$Packages | Install-UscPackage -InstanceName 'OnPrem-Voyado-v261-ws' -Arguments $Arguments -UpdateInstance