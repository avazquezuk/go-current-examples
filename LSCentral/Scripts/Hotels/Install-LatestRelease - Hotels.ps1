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
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}
    #@{ Id = 'ls-central-demo-database'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '' }
    @{ Id = 'ls-hotels-app-runtime'; Version = '' }
    @{ Id = 'ls-hotels-configuration-packages'; Version = '' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '' }
    #@{ Id = 'bc-performance-toolkit'; Version = '' }
    #@{ Id = 'bc-test-library-any'; Version = '' }
    #@{ Id = 'bc-al-test-runner'; Version = '' }
    #@{ Id = 'bc-base-application-tests-test-libraries'; Version = '' }
    
)

$Packages | Install-UscPackage -InstanceName 'LSC-Release-Hotels' -Arguments $Arguments -UpdateInstance