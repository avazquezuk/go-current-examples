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
    'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    @{ Id = 'ls-central-demo-database'; Version = '!^ 22.3' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 22.3' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 22.3' }
    @{ Id = 'ls-hotels-app-runtime'; Version = '!^ 22.3' }
    @{ Id = 'ls-hotels-configuration-packages'; Version = '!^ 22.3' }
    #@{ Id = 'bc-performance-toolkit'; Version = '' }
    #@{ Id = 'bc-test-library-any'; Version = '' }
    #@{ Id = 'bc-al-test-runner'; Version = '' }
)

$Packages | Install-UscPackage -InstanceName 'LSCentral-Hotels-22_3' -Arguments $Arguments -UpdateInstance