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
        .\Install-LatestReleaseWithExistingDjurs21_6.ps1 -ConnectionString 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=djurs_hosp_21_1_60;Integrated Security=True' -ServiceUser 'alejandrova@lsretail.com' -ServicePassword (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
        ```
        This example installs lastest version fo LS Central, connects the database DATABASENAME on the server SQLSERVERMACHINE.
        With the user domain\user running the Business Central service tier.

#>
param(
    $ConnectionString = 'Data Source=PTPOPW04JD56\AVMSQLSERVER;Initial Catalog=djurs_hosp_21_1_60;Integrated Security=True',
    [Parameter(Mandatory)]
    $InstanceName = 'djurs_hosp_21160'
)
$ErrorActionPreference = 'stop'

$Arguments = @{
    'bc-server' = @{
        ConnectionString = $ConnectionString
        AllowSessionCallSuspendWhenWriteTransactionStarted = 'true'
        LicenseUri = 'C:\Development\5337065 (33).bclicense'
        DeveloperServicesEnabled = 'true'
        PublicWebBaseUrl = 'http://localhost:8080/djurs_hosp_21160'
        #ServiceUser = $ServiceUser
        #ServicePassword = (ConvertFrom-SecureString $ServicePassword).ToString()
    }
}

$Packages = @(
    @{ Id = 'bc-server'; Version = '' }
    @{ Id = 'bc-web-client'; Version = '' }
    @{ Id = 'bc-system-symbols'; Version = '' }
    @{ Id = 'bc-system-application-runtime'; Version = '' }
    @{ Id = 'ls-central-app-runtime'; Version = '!^ 21.1' }
    @{ Id = 'locale/ls-central-dk-runtime'; Version = '!^ 21.1' }
    @{ Id = 'map/ls-central-to-bc'; Version = '!^ 21.1' }
    @{ Id = 'ls-central-toolbox-server'; Version = '' }
    @{ Id = 'ls-setup-helper'; Version = '' }
)
 
$Packages | Install-UscPackage -InstanceName $InstanceName -Arguments $Arguments -UpdateInstance