#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server'                = @{
        DeveloperServicesEnabled                           = 'true'
        AllowForceSync                                     = 'true'
        ClientServicesCredentialType                       = 'NavUserPassword'
        #ServicesCertificateThumbprint                      = 'e4e910349c5dedf93b257b1b5bfc310b16efad07'
        ServicesCertificateThumbprint                      = '0bce836390fa22e9233d11bbc608946b32330700'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        #ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=Scandlines-SSK-v24;Integrated Security=True'
        ConnectionString = 'Data Source=EUPF59EVRB;Initial Catalog=Scandlines-SSK-v24;Integrated Security=True'
    }
    'bc-web-client'            = @{
        DnsIdentity = 'localhost'
    }
}

$Packages = @(
    @{ Id = 'bc-web-client'; Version = '!^ 24.0' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 24.0' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 24.0' }
)

$Packages | Install-UscPackage -InstanceName 'Scandlines-SSK-v24-WS' -Arguments $Arguments -UpdateInstance