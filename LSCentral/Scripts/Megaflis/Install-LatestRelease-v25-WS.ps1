#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install LS Central with NavUserPassword and necessary certificate.
    
    .DESCRIPTION
        This will install LS Central configured to use NavUserPassword and installs
        self-signed certificates. 

        The certificate packages can be created by running the script:

        PS C:\> & ..\Packages\Certificates\Example.ps1 -Import

        The script will create self-signed certificates.
#>
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server'                = @{
        DeveloperServicesEnabled                           = 'true'
        AllowForceSync                                     = 'true'
        ClientServicesCredentialType                       = 'NavUserPassword'
        ServicesCertificateThumbprint                      = '${my-private-certificate.CertificateThumbprint}'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=Megaflis-HO-v25;Integrated Security=True'
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
    #@{ Id = 'bc-system-application-runtime'; Version = '' }
    #@{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 25.0' }
    @{ Id = 'locale/ls-central-no-runtime'; Version = '!^ 25.0' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 25.0' }
)
 
$Packages | Install-UscPackage -InstanceName 'Megaflis-HO-v25-WS' -UpdateStrategy 'Automatic' -Arguments $Arguments