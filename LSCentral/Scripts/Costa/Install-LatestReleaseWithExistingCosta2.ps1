#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=CostaCoffee2;Integrated Security=True'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        #LicenseUri = 'C:\Development\5337065 (24).bclicense'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/CostaCoffee-DEV'
        NoDatabaseUpgrades = 'False'
        AllowForceSync = 'true'
        PortSharing = 'True'
    }
    'bc-demo-database-gb' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=CostaCoffee2;Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'bc-server'; Version = '24.0.18037.0' }
    @{ Id = 'bc-demo-database-gb'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    #@{ Id = 'bc-system-symbols'; Version = '24.0.18037.0' }
    #@{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-gb'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    #@{ Id = 'map/ls-central-to-bc'; Version = '!_ 24.0.0.0' }
)

$Packages | Install-UscPackage -InstanceName 'CostaCoffee-DEV' -Arguments $Arguments -UpdateInstance