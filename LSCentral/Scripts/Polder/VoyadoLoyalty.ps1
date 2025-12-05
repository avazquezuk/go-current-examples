#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
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
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    @{ Id = 'ls-central-demo-database'; Version = '' }
    @{ Id = 'bc-server'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-symbols'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app'; Version = '' }
    @{ Id = 'locale/ls-central-no'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
)
 
$Packages | Install-UscPackage -InstanceName 'Voyado-LoyaltyIntegration-NO' -Arguments $Arguments -UpdateInstance