$ErrorActionPreference = 'stop'

Import-Module UpdateServiceServer

# Specify the LS Central version, empty will get the latest version.
$LsCentralVersion = ''

$Packages = @(
    #@{ Id = 'sql-server-express'; Version = '^' }
    #@{ Id = "bc-web-client"; 'Version' = "" }
    #@{ Id = 'ls-central-demo-database'; Version = $LsCentralVersion }
    #@{ Id = 'ls-central-app-runtime'; Version = $LsCentralVersion }
    #@{ Id = 'ls-hardware-station'; Version = $LsCentralVersion }
    #@{ Id = 'map/ls-central-to-bc'; Version = $LsCentralVersion }
    @{ Id = 'internal/ls-central-dev-license'; Version = '' }
    #@{ Id = 'ls-dd-service'; Version = '^ >=3.0 <4.0' }
)

$Packages | Copy-UssPackageFromServer -SourceServer 'https://updateservice.lsretail.com'