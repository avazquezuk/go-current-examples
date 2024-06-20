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
        #LicenseUri = 'C:\Development\5337065 (24).bclicense'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/LSC-Release'
        NoDatabaseUpgrades = 'False'
    }
    'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    @{ Id = 'ls-central-demo-database'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '' }
    #@{ Id = 'ls-hotels-app-runtime'; Version = '' }
    #@{ Id = 'ls-hotels-configuration-packages'; Version = '' }
    #@{ Id = 'bc-performance-toolkit'; Version = '' }
    #@{ Id = 'bc-test-library-any'; Version = '' }
    #@{ Id = 'bc-al-test-runner'; Version = '' }
)

$Packages | Install-UscPackage -InstanceName 'LSC-LatestRelease-SSK' -Arguments $Arguments -UpdateInstance