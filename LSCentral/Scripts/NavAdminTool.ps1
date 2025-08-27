#--------------------------------------------------------------------------
#     Copyright (c) Microsoft Corporation.  All rights reserved.
#--------------------------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -eq 5) {
  $errorVariable = $null

  # Import-Module or register Snap-in, that will enable side-by-side registrations
  function RegisterSnapIn($snapIn, $visibleName)
  {
    if(Get-Module $snapIn)
    {
      return
    }
  
    $nstPath = "C:\Program Files\LS Retail\Update Service\Instances\Megaflis-HO-v25\Service"
    $resolvedManagementPath = Join-Path (Get-ItemProperty -path $nstPath).Path "\Management"
    write-host $resolvedManagementPath
    $snapInAssembly = Join-Path $resolvedManagementPath "\$snapIn.psd1"
    if(!(Test-Path $snapInAssembly)) { $snapInAssembly = Join-Path $resolvedManagementPath "\$snapIn.dll" }
  
    # First try to import the module
    Import-Module $snapInAssembly -ErrorVariable errorVariable -ErrorAction SilentlyContinue
  
    if (Check-ErrorVariable -eq $true)
    {
      # fallback to add the snap-in
      if ((Get-PSSnapin -Name $snapIn -ErrorAction SilentlyContinue) -eq $null)
      {
          if ((Get-PSSnapin -Registered $snapIn -ErrorAction SilentlyContinue) -eq $null)
          {
              write-host -fore Red "Couldn't register $visibleName"
              write-host -fore Red "Some cmdlets may not be available`n"
          }
          else
          {
              Add-PSSnapin $snapIn
          }
      }
    }
  }
  
  # Check if there is any error in the ErrorVariable
  function Check-ErrorVariable
  {
      return ($errorVariable -ne $null -and $errorVariable.Count -gt 0)
  }
  
  # Welcome message
  write-host "`nWelcome to the Server Admin Tool Shell!"
  write-host "For a complete list of Server cmdlets type`n"
  
  write-host -fore Yellow "Get-Command -Module Microsoft.Dynamics.Nav.Management"
  
  # Register Microsoft Dynamics NAV Management Snap-in
  RegisterSnapIn "Microsoft.Dynamics.Nav.Management" "Microsoft Dynamics NAV Management Snap-in"
  
  
  # Print available commands
  Get-Command -Module Microsoft.Dynamics.Nav.Management
  
  # Microsoft internal usage only # Print feature switches if any
  if ($env:NAV_INTERNAL_FEATURESWITCHOVERRIDES -ne $null)
  {
      Write-Host
      Write-Host -ForegroundColor Green "Enabled feature switches: $env:NAV_INTERNAL_FEATURESWITCHOVERRIDES"
  }  
} 
else {
  $errorVariable = $null

  # Import-Module or register Snap-in, that will enable side-by-side registrations
  function RegisterSnapIn($snapIn, $visibleName)
  {
    $dllName = $snapIn + ".dll" 
    if(Get-Module $snapIn)
    {
      return
    }
    $nstPath = "C:\Program Files\LS Retail\Update Service\Instances\Megaflis-HO-v25\Service"
    $resolvedManagementPath = Join-Path (Get-ItemProperty -path $nstPath).Path "\Admin"
  
    # First try to import the module
    Import-Module ( Join-Path $resolvedManagementPath $dllName)  -ErrorVariable errorVariable -ErrorAction SilentlyContinue
  
    if (Check-ErrorVariable -eq $true)
    {
      $backup = Join-Path (Join-Path $PSScriptRoot "\Admin") $dllName
      # fallback to add the snap-in
      if ((Import-Module $backup  -ErrorVariable errorVariable -ErrorAction SilentlyContinue) -eq $null)
      {
          if (Test-Path env:Nav_Management_Location ) {
            $backup = Join-Path $env:Nav_Management_Location $dllName
          } else {
            $backup = "dummy"
          }
          if ((Import-Module $backup  -ErrorVariable errorVariable -ErrorAction SilentlyContinue) -eq $null)
          {
            if(!(Get-Module $snapIn))
            {
              write-host -fore Red "Couldn't register $visibleName"
              write-host -fore Red "Some cmdlets may not be available`n"
            }
          }
      }
    }
  }
  
  # Check if there is any error in the ErrorVariable
  function Check-ErrorVariable
  {
      return ($errorVariable -ne $null -and $errorVariable.Count -gt 0)
  }
  
  # Welcome message
  write-host "`nWelcome to the Server Admin Tool Shell!"
  write-host "For a complete list of Server cmdlets type`n"
  
  write-host -fore Yellow "Get-Command -Module Microsoft.BusinessCentral.Management, Microsoft.BusinessCentral.Apps.Management`n"
  
  # Register Microsoft Dynamics NAV Management Snap-in
  RegisterSnapIn "Microsoft.BusinessCentral.Management" "Microsoft BusinessCentral Management Snap-in"
  
  # Register Microsoft Dynamics NAV Apps Management Snap-in
  RegisterSnapIn "Microsoft.BusinessCentral.Apps.Management" "Microsoft BusinessCentral App Management Snap-in"
  
  
  # Print available commands
  Get-Command -Module Microsoft.BusinessCentral.Management, Microsoft.BusinessCentral.Apps.Management
  
  # Microsoft internal usage only # Print feature switches if any
  if ($env:NAV_INTERNAL_FEATURESWITCHOVERRIDES -ne $null)
  {
      Write-Host
      Write-Host -ForegroundColor Green "Enabled feature switches: $env:NAV_INTERNAL_FEATURESWITCHOVERRIDES"
  }  
}

# SIG # Begin signature block
# MIIoNwYJKoZIhvcNAQcCoIIoKDCCKCQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBnwkIAd696peB2
# i7D4Az4Ul4+FLgXR983o+dv/H0KdXqCCDYUwggYDMIID66ADAgECAhMzAAAEA73V
# lV0POxitAAAAAAQDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjQwOTEyMjAxMTEzWhcNMjUwOTExMjAxMTEzWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCfdGddwIOnbRYUyg03O3iz19XXZPmuhEmW/5uyEN+8mgxl+HJGeLGBR8YButGV
# LVK38RxcVcPYyFGQXcKcxgih4w4y4zJi3GvawLYHlsNExQwz+v0jgY/aejBS2EJY
# oUhLVE+UzRihV8ooxoftsmKLb2xb7BoFS6UAo3Zz4afnOdqI7FGoi7g4vx/0MIdi
# kwTn5N56TdIv3mwfkZCFmrsKpN0zR8HD8WYsvH3xKkG7u/xdqmhPPqMmnI2jOFw/
# /n2aL8W7i1Pasja8PnRXH/QaVH0M1nanL+LI9TsMb/enWfXOW65Gne5cqMN9Uofv
# ENtdwwEmJ3bZrcI9u4LZAkujAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQU6m4qAkpz4641iK2irF8eWsSBcBkw
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMjkyNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AFFo/6E4LX51IqFuoKvUsi80QytGI5ASQ9zsPpBa0z78hutiJd6w154JkcIx/f7r
# EBK4NhD4DIFNfRiVdI7EacEs7OAS6QHF7Nt+eFRNOTtgHb9PExRy4EI/jnMwzQJV
# NokTxu2WgHr/fBsWs6G9AcIgvHjWNN3qRSrhsgEdqHc0bRDUf8UILAdEZOMBvKLC
# rmf+kJPEvPldgK7hFO/L9kmcVe67BnKejDKO73Sa56AJOhM7CkeATrJFxO9GLXos
# oKvrwBvynxAg18W+pagTAkJefzneuWSmniTurPCUE2JnvW7DalvONDOtG01sIVAB
# +ahO2wcUPa2Zm9AiDVBWTMz9XUoKMcvngi2oqbsDLhbK+pYrRUgRpNt0y1sxZsXO
# raGRF8lM2cWvtEkV5UL+TQM1ppv5unDHkW8JS+QnfPbB8dZVRyRmMQ4aY/tx5x5+
# sX6semJ//FbiclSMxSI+zINu1jYerdUwuCi+P6p7SmQmClhDM+6Q+btE2FtpsU0W
# +r6RdYFf/P+nK6j2otl9Nvr3tWLu+WXmz8MGM+18ynJ+lYbSmFWcAj7SYziAfT0s
# IwlQRFkyC71tsIZUhBHtxPliGUu362lIO0Lpe0DOrg8lspnEWOkHnCT5JEnWCbzu
# iVt8RX1IV07uIveNZuOBWLVCzWJjEGa+HhaEtavjy6i7MIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGggwghoEAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAQDvdWVXQ87GK0AAAAA
# BAMwDQYJYIZIAWUDBAIBBQCggZAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# LwYJKoZIhvcNAQkEMSIEIGRmgxMCkYGCh4fCAO8AP2qq+At/O7IEYyl09wODUeHz
# MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEBBQAEggEAOt13yJ3OIs4U
# 5qjkYtZ7cmW4PilWy4mtvmCyfwNSPyHQ3q3SmEu1PD+OH/64jTxq3Ff26bPDMVX0
# Un9RKv3Otqa+8Y5rQcP4B1LQ6ft1lwiDpWTL3oDYuY3ArMCIgOLpWMXlZP72wGy2
# 7UA1muV53K/VH0bk68ZFhZgvK6UNJj1m1g6YOKU3F9Bo63l/jFR9kaVPa4yAhtc6
# 18Qv+nVNTP6rBrESs24sEBG83CZBAa24dxhElPdasxh5HZ85Yldz4Kqc2PYumLXc
# 8MhtUYACjA8SJsydNcvGYHCiXNrnFep1nDRa3mGb/nigGSJ1C2JjS2sc7EXSLYor
# PWGNe+/P1KGCF7AwghesBgorBgEEAYI3AwMBMYIXnDCCF5gGCSqGSIb3DQEHAqCC
# F4kwgheFAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFaBgsqhkiG9w0BCRABBKCCAUkE
# ggFFMIIBQQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFlAwQCAQUABCDVUEBVFa43
# ny8+DoGIYOQ8LKzw5Ovi/0RQg93+71mCPwIGaBLOKISPGBMyMDI1MDUwNzE2MzAz
# Ny4xOTNaMASAAgH0oIHZpIHWMIHTMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25z
# IExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo1NzFBLTA1RTAtRDk0
# NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCCEf4wggco
# MIIFEKADAgECAhMzAAAB+8vLbDdn5TCVAAEAAAH7MA0GCSqGSIb3DQEBCwUAMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTI0MDcyNTE4MzExM1oXDTI1
# MTAyMjE4MzExM1owgdMxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRl
# ZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjU3MUEtMDVFMC1EOTQ3MSUwIwYD
# VQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAqMJWQeWAq4LwvSjYsjP0Uvhvm0j0aAOJiMLg0sLf
# xKoTXAdKD6oMuq5rF5oEiOxV+9ox0H95Q8fhoZq3x9lxguZyTOK4l2xtcgtJCtjX
# RllM2bTpjOg35RUrBy0cAloBU9GJBs7LBNrcbH6rBiOvqDQNicPRZwq16xyjMidU
# 1J1AJuat9yLn7taifoD58blYEcBvkj5dH1la9zU846QDeOoRO6NcqHLsDx8/zVKZ
# xP30mW6Y7RMsqtB8cGCgGwVVurOnaNLXs31qTRTyVHX8ppOdoSihCXeqebgJCRzG
# 8zG/e/k0oaBjFFGl+8uFELwCyh4wK9Z5+azTzfa2GD4p6ihtskXs3lnW05UKfDJh
# AADt6viOc0Rk/c8zOiqzh0lKpf/eWUY2o/hvcDPZNgLaHvyfDqb8AWaKvO36iRZS
# XqhSw8SxJo0TCpsbCjmtx0LpHnqbb1UF7cq09kCcfWTDPcN12pbYLqck0bIIfPKb
# c7HnrkNQks/mSbVZTnDyT3O8zF9q4DCfWesSr1akycDduGxCdKBvgtJh1YxDq1sk
# TweYx5iAWXnB7KMyls3WQZbTubTCLLt8Xn8t+slcKm5DkvobubmHSriuTA3wTyIy
# 4FxamTKm0VDu9mWds8MtjUSJVwNVVlBXaQ3ZMcVjijyVoUNVuBY9McwYcIQK62wQ
# 20ECAwEAAaOCAUkwggFFMB0GA1UdDgQWBBRHVSGYUNQ3RwOl71zIAuUjIKg1KjAf
# BgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQ
# hk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQl
# MjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBe
# MFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Nl
# cnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAM
# BgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQE
# AwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAwzoIKOY2dnUjfWuMiGoz/ovoc1e86VwW
# aZNFdgRmOoQuRe4nLdtZONtTHNk3Sj3nkyBszzxSbZEQ0DduyKHHI5P8V87jFttG
# nlR0wPP22FAebbvAbutkMMVQMFzhVBWiWD0VAnu9x0fjifLKDAVXLwoun5rCFqwb
# asXFc7H/0DPiC+DBn3tUxefvcxUCys4+DC3s8CYp7WWXpZ8Wb/vdBhDliHmB7pWc
# msB83uc4/P2GmAI3HMkOEu7fCaSYoQhouWOr07l/KM4TndylIirm8f2WwXQcFEzm
# UvISM6ludUwGlVNfTTJUq2bTDEd3tlDKtV9AUY3rrnFwHTwJryLtT4IFhvgBfND3
# mL1eeSakKf7xTII4Jyt15SXhHd5oI/XGjSgykgJrWA57rGnAC7ru3/ZbFNCMK/Jj
# 6X8X4L6mBOYa2NGKwH4A37YGDrecJ/qXXWUYvfLYqHGf8ThYl12Yg1rwSKpWLolA
# /B1eqBw4TRcvVY0IvNNi5sm+//HJ9Aw6NJuR/uDR7X7vDXicpXMlRNgFMyADb8AF
# IvQPdHqcRpRorY+YUGlvzeJx/2gNYyezAokbrFhACsJ2BfyeLyCEo6AuwEHn511P
# KE8dK4JvlmLSoHj7VFR3NHDk3zRkx0ExkmF8aOdpvoKhuwBCxoZ/JhbzSzrvZ74G
# VjKKIyt5FA0wggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqG
# SIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkg
# MjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4X
# YDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTz
# xXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7
# uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlw
# aQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedG
# bsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXN
# xF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03
# dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9
# ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5
# UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReT
# wDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZ
# MBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8
# RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAE
# VTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAww
# CgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
# AgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb
# 186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29t
# L3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoG
# CCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZI
# hvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9
# MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2Lpyp
# glYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OO
# PcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8
# DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA
# 0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1Rt
# nWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjc
# ZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq7
# 7EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJ
# C4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328
# y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYID
# WTCCAkECAQEwggEBoYHZpIHWMIHTMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25z
# IExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo1NzFBLTA1RTAtRDk0
# NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcG
# BSsOAwIaAxUABHHn7NCGusZz2RfVbyuwYwPykBWggYMwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsFAAIFAOvF3gowIhgPMjAy
# NTA1MDcxMzI2MzRaGA8yMDI1MDUwODEzMjYzNFowdzA9BgorBgEEAYRZCgQBMS8w
# LTAKAgUA68XeCgIBADAKAgEAAgITcAIB/zAHAgEAAgISZzAKAgUA68cvigIBADA2
# BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIB
# AAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQA7O1JwNiHNd1RB3C7X9htqzSqJxbCB
# 4oa+xzlvwZ06CGqNSJ5zXHar59jDz5Bt7jG9+2FX5dNj0fDZLrcV3pJ+kaVEL0q7
# 4mUA4z4P0fXXLWOqYrd9oTG6EUm3S67Ozt0mIfgBjpcBq4nPLrSa6+ZgWaFPZo58
# URgwxbMgIRn1UCX9nu6DDobpPVywb11S2AZqZVw0JqCi0S4GysY7EqeonzbdkEWx
# JScXccvL4KnvXoRl8r7ziesZ7tfq5d78znQ424zqyCK3JY2fLJFDuYuJEYmA8gOg
# WiFYGEuNs+v1QrciviU4b2bxJx3vJPzL9HxQrAcOEq0I7I/lZ3pVlUb/MYIEDTCC
# BAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEm
# MCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAH7y8ts
# N2flMJUAAQAAAfswDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsq
# hkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQg9PzQ3GntI+6HLpyTjkdXQiwfVMDD
# rUeLWlyu1N52vkswgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCA52wKr/KCF
# lVNYiWsCLsB4qhjEYEP3xHqYqDu1SSTlGDCBmDCBgKR+MHwxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFBDQSAyMDEwAhMzAAAB+8vLbDdn5TCVAAEAAAH7MCIEIGoixkmEMGCe
# 8SR4+hWiQP++tJZFmHV7czO8EM92EpQ7MA0GCSqGSIb3DQEBCwUABIICAHhrXd4O
# b8honVwGhT1RpLz1gBCqJpoOA2+Xu6yCutWBc56X1PdZH1FhYYpJQpyBYpC3GPqB
# BBq3zeS7roeDDezOxDXi1ACIPAeEh5fuDXxgkHasBcIcHRYw0e/qe0iO4PTcyE91
# r+oXkDmh2M4wZ7VrLPeV/0AK9HDCGrSVatEgTszkUKNFq/NxyWO+HHozCZ3DDQVU
# vvutxedH5RVSmwRgA8Kw0vY7FqvWnNnZN+xJMSnCcvTedu+GefUrUQO7Od0kE/BC
# WyDF4DQRo7Sni45ZQzXND6Bn1Jl+ETwk9g/DNI5TbpA58nloW8wTwFn+10w1fJ1R
# tlOiV/nPyE3Fb04klEAP7uKn0VOo8N6Y14PYH75PtXkIoEZ4KtFUtGV5j/09zwYh
# arP9XpG0FjQsiI8DUEWIfAlUI0BTmB0oLhUvP5J1okg00jikeoNGTHlCCkYozUYL
# zeDfeuydUbue4M6Y5FiSqoCnldP8P6tSV9aazsa/4hAoqF4XMDoz2adkd00qFsXj
# 3vWZlVKQ83eI0HTpVEv6/TZVWQ+HW4OzNMgTDQjmt/7waDoqeMLBcWJZo0X0uBbU
# wvyMgGWO9HQlI8GbgPiyWoEGOu2ouqIC7a1jSUqatkQ0KnTDS3ROTfXy7t2PyrYp
# VG7GZbsGnXyGzmDSv/PFkyVz9BE4AM0q0k6b
# SIG # End signature block
