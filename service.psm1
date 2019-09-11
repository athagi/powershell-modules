function Test-Installed {
  Param(
    [parameter(Mandatory)][string]$Name
  )
  $InstallProduct = Get-WmiObject Win32_Product | where-object {$_.Name -eq "$Name"}
  if($InstallProduct) {
    return $true
  } else {
    return $false
  }
}

function Test-Service {
  Param(
    [parameter(Mandatory = $true)][String]$Name
  )
  $Service = Get-Service | Where-Object { $_.Name -eq "$Name"}

  if($Service) {
    return $true
  } else {
    return $false
  }
}

Export-ModuleMember -Function Test-Service,Test-Installed