#requires -RunAsAdministrator
<#
    .SYNOPSIS
        Install the latest LS Central release on top of existing database.

    .PARAMETER ConnectionString
        Specifies a connection string for existing database.
    
    .PARAMETER ServiceUser
        Specifies a Windows users that run the Business Central service.
        The user must have access and db_owner permissions to the existing database.

    .PARAMETER ServicePassword
        Specifies the password for the service user.

    .EXAMPLE
        ```powershell
        Install-LatestRelease.ps1 -ConnectionString 'Data Source=SQLSERVERMACHINE;Initial Catalog=DATABASENAME;Integrated Security=True' -ServiceUser 'domain\user' -ServicePassword (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
        .\Install-LatestReleaseWithExistingVitaCOv23.ps1 -ConnectionString 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=vitaposco_v23;Integrated Security=True' -ServiceUser 'alejandrova@lsretail.com' -ServicePassword (ConvertTo-SecureString -String 'Password' -AsPlainText -Force)
        ```
        This example installs lastest version fo LS Central, connects the database DATABASENAME on the server SQLSERVERMACHINE.
        With the user domain\user running the Business Central service tier.

#>
param(
    $ConnectionString = 'Data Source=${System.SqlServerInstance};Initial Catalog=${Package.databaseName};Integrated Security=True',
    $InstanceName = 'Megaflis-ST',
    $databaseName = 'MegaflisStoreV27'
)
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/${Package.InstanceName}'
    }
    'ls-central-demo-database' = @{
        ConnectionString = 'Data Source=PTPOPF5VSEB7\AVMSQLSERVER;Initial Catalog=${Package.InstanceName};Integrated Security=True'
    }
}

$Packages = @(
    #@{ Id = 'ls-central-demo-database'; Version = '' }
    @{ Id = 'bc-server'; Version = '^! 27.0' }
    @{ Id = 'bc-web-client'; Version = '^! 27.0' }
    @{ Id = 'ls-central-app-runtime'; Version = '^! 27.0' }
    @{ Id = 'locale/ls-central-no-runtime'; Version = '^! 27.0' }
    @{ Id = 'internal/ls-central-dev-license'; Version = '^!' }
    @{ Id = 'ls-loyalty-integration-voyado-app'; Version = '^! 27.0' }
    @{ Id = 'map/ls-central-to-bc'; Version = '^! 27.0' }
)
 
$Packages | Install-UscPackage -InstanceName $InstanceName -UpdateInstance