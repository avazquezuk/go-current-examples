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
        LicenseUri = 'C:\Development\5337065 (24).bclicense'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/DF-20_3'
    }
        'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    @{ Id = 'ls-central-demo-database'; Version = '!^ 20.3' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 20.3' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 20.3' }
)

$Packages | Install-UscPackage -InstanceName 'DF-20_3' -Arguments $Arguments -UpdateInstance