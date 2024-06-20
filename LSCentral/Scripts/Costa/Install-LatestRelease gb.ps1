#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central version.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
    }
    'bc-demo-database-gb' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=CostaCoffee;Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    @{ Id = 'bc-demo-database-gb'; Version = '24.0.18037.0' }
    @{ Id = 'bc-web-client'; Version = '24.0.18037.0' }
    @{ Id = 'bc-system-application'; Version = '24.0.16410.18056' }
    @{ Id = 'bc-base-application-gb'; Version = '24.0.16410.18056' }
    #@{ Id = 'ls-central-app'; Version = '' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    #@{ Id = 'map/ls-central-to-bc'; Version = '' }

    
)
 
$Packages | Install-UscPackage -InstanceName 'CostaCoffeeDev' -Arguments $Arguments