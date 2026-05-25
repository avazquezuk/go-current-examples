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

$ErrorActionPreference = 'stop'
$ExistingInstanceName = 'Vita-HO-v27'
$BcServer = Get-UscInstalledPackage -PackageId 'bc-server' -InstanceName $ExistingInstanceName
$Arguments = @{
    "bc-server" = @{
        ConnectionString = $BcServer.Info.ConnectionString
        DeveloperServicesEnabled = 'true'
        AllowForceSync = 'true'
        ClientServicesCredentialType = 'NavUserPassword'
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        NoDatabaseUpgrades = 'true'
        PortSharing = 'true'
    }
    "bc-web-client" = @{
        ClientServicesCredentialType = 'NavUserPassword'
    }
}
$Packages = @(
    @{ Id = 'bc-server'; VersionQuery = $BcServer.Version}
    @{ Id = 'bc-web-client'; VersionQuery = $BcServer.Version}
)
 $Packages | Install-GocPackage -InstanceName 'Vita-WS-27' -UpdateStrategy 'Manual' -Arguments $Arguments -UpdateInstance 