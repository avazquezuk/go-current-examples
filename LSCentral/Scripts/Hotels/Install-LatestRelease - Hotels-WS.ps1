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
        ServicesCertificateThumbprint                      = '${my-private-certificate.CertificateThumbprint}'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=LSC-Release-Hotels;Integrated Security=True'
    }
    'bc-web-client'            = @{
        DnsIdentity = '${my-public-certificate.DnsIdentity}'
    }
}

$Packages = @(
    # Optional, uncomment to include:
    #@{ Id = 'sql-server-express'; VersionQuery = '^-'}

    # You can find out how to create the my-public-certificate and
    # my-private-certificate packages in the package examples.
    @{ Id = "my-public-certificate"; Version = "" }
    @{ Id = "my-private-certificate"; Version = "" }

    #@{ Id = 'ls-central-demo-database'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '' }
    @{ Id = 'ls-hotels-app-runtime'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '' }
)

$Packages | Install-UscPackage -InstanceName 'LSC-Release-Hotels-WS' -Arguments $Arguments -UpdateInstance