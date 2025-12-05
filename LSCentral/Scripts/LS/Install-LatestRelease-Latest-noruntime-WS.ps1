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
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=LSC-LoyaltyIntegrationHO-Noruntime;Integrated Security=True'
        PortSharing ='true'
    }
    'bc-web-client'            = @{
        DnsIdentity = '${my-public-certificate.DnsIdentity}'
        ClientServicesCredentialType = 'NavUserPassword'
    }
}

$Packages = @(

    # You can find out how to create the my-public-certificate and
    # my-private-certificate packages in the package examples.
    @{ Id = "my-public-certificate"; Version = "" }
    @{ Id = "my-private-certificate"; Version = "" }

    # Optional, uncomment to include: BUSINESS CENTRAL packages
    @{ Id = 'bc-server'; VersionQuery = $BcServer.Version }
    @{ Id = 'bc-web-client'; VersionQuery = $BcServer.Version }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    @{ Id = 'map/ls-central-to-bc'; Version = '' }
)
 
$Packages | Install-UscPackage -InstanceName 'LSC-LoyInt-HO-NR-WS' -Arguments $Arguments -UpdateInstance