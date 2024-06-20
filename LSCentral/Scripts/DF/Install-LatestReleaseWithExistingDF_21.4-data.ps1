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
        .\Install-LatestReleaseWithExistingDF_21.4-data.ps1 -ConnectionString 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=DF-21_4-data;Integrated Security=True' -ServiceUser 'alejandrova@lsretail.com' -ServicePassword (ConvertTo-SecureString -String 'Zpyv5xhvb1210.' -AsPlainText -Force)
        ```
        This example installs lastest version fo LS Central, connects the database DATABASENAME on the server SQLSERVERMACHINE.
        With the user domain\user running the Business Central service tier.

#>
param(
    $ConnectionString = 'Data Source=${System.SqlServerInstance};Initial Catalog=${Package.InstanceName};Integrated Security=True',
    [Parameter(Mandatory)]
    $ServiceUser,
    [Parameter(Mandatory)]
    [SecureString] $ServicePassword,
    $InstanceName = 'DF_21_4_data'
)
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        ConnectionString = $ConnectionString
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        LicenseUri = 'C:\Development\5337065 (24).bclicense'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/DF_21_4_data'
        ServiceUser = $ServiceUser
        ServicePassword = (ConvertFrom-SecureString $ServicePassword).ToString()
        NoDatabaseUpgrades = 'False'
    }
}

$Packages = @(
    @{ Id = 'bc-server'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-symbols'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'bc-base-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 21.4' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 21.4' }
)
 
$Packages | Install-UscPackage -InstanceName $InstanceName -Arguments $Arguments -UpdateInstance -ErrorAction Continue
