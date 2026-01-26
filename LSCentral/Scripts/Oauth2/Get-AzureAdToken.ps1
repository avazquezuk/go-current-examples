<#
    .SYNOPSIS
        Request an OAuth2 access token from Azure AD using client credentials flow.
    
    .DESCRIPTION
        Authenticates against Azure AD using the client credentials (app-only) flow
        and returns an access token. This is suitable for service-to-service 
        authentication where no user interaction is required.
    
    .PARAMETER TenantId
        The Azure AD tenant ID. Defaults to '9e93291e-a20e-4b8c-93f9-3ae24c57d256'.
    
    .PARAMETER ClientId
        The application (client) ID registered in Azure AD.
    
    .PARAMETER ClientSecret
        The client secret for authentication.
    
    .PARAMETER Resource
        The resource URI to request access to (e.g., 'https://graph.microsoft.com').
        The '.default' scope is automatically appended.
    
    .EXAMPLE
        # Interactive - prompt for secret
        $Secret = Read-Host -Prompt 'Enter client secret'
        .\Get-AzureAdToken.ps1 -ClientId 'your-client-id' -ClientSecret $Secret -Resource 'https://graph.microsoft.com'
    
    .EXAMPLE
        # Scripted - pass secret directly (use only in secure environments)
        $Token = .\Get-AzureAdToken.ps1 -ClientId 'your-client-id' -ClientSecret 'your-secret-value' -Resource 'https://graph.microsoft.com'
        
        # Use the token in subsequent API calls
        $Headers = @{ Authorization = "Bearer $Token" }
        Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/me' -Headers $Headers
    
    .EXAMPLE
        # With custom tenant ID and custom API resource
        $Secret = Read-Host -Prompt 'Enter client secret'
        .\Get-AzureAdToken.ps1 -TenantId 'your-tenant-id' -ClientId 'your-client-id' -ClientSecret $Secret -Resource 'api://your-api'
#>
param(
    [Parameter()]
    [string] $TenantId = '9e93291e-a20e-4b8c-93f9-3ae24c57d256',
    
    [Parameter(Mandatory = $true)]
    [string] $ClientId,
    
    [Parameter(Mandatory = $true)]
    [string] $ClientSecret,
    
    [Parameter(Mandatory = $true)]
    [string] $Resource
)

$ErrorActionPreference = 'stop'

# Construct scope with .default suffix
$Scope = "$Resource/.default"

$TokenEndpoint = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

$Body = @{
    grant_type    = 'client_credentials'
    client_id     = $ClientId
    client_secret = $ClientSecret
    scope         = $Scope
}

try {
    $Response = Invoke-RestMethod -Method Post -Uri $TokenEndpoint -ContentType 'application/x-www-form-urlencoded' -Body $Body
    return $Response.access_token
}
catch {
    $ErrorMessage = $_.Exception.Message
    
    # Try to extract Azure AD error details from the response
    if ($_.ErrorDetails.Message) {
        try {
            $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
            $AadError = $ErrorDetails.error
            $AadErrorDescription = $ErrorDetails.error_description
            
            switch ($AadError) {
                'invalid_client' {
                    throw "Authentication failed: Invalid client ID or client secret. Verify your credentials are correct. Details: $AadErrorDescription"
                }
                'unauthorized_client' {
                    throw "Authentication failed: The client is not authorized for this grant type. Ensure the app registration allows client credentials flow. Details: $AadErrorDescription"
                }
                'invalid_scope' {
                    throw "Authentication failed: Invalid resource '$Resource'. Verify the resource URI is correct and the app has the required permissions. Details: $AadErrorDescription"
                }
                'invalid_request' {
                    throw "Authentication failed: Invalid request. Details: $AadErrorDescription"
                }
                default {
                    throw "Authentication failed: $AadError - $AadErrorDescription"
                }
            }
        }
        catch [System.ArgumentException] {
            # JSON parsing failed, use original error
            throw "Authentication failed: $ErrorMessage"
        }
    }
    
    throw "Authentication failed: $ErrorMessage"
}
