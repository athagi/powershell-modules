function Edit-Firewall {
  Param(
    [parameter(Mandatory = $true)][bool]$Status
  )
  Write-Debug "start Edit-Firewall $Status"
  Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled $([System.Convert]::ToString($Status))
}

function Set-HighPerformance {
  Write-Debug "start Set-HighPerformance"
  # 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c is GUID of high-performance power plan
  powercfg.exe /SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
}

function Confirm-AdministratorPrivillage {
  $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  $IsRoleStatus = $WindowsPrincipal.IsInRole("Administrators")
  if ($IsRoleStatus -eq "true") {
    return $true
  }
  else {
    return $false
  }
}

Export-ModuleMember -Function Edit-Firewall, Set-HighPerformance, Confirm-AdministratorPrivillage
