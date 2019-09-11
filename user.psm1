<#
.SYNOPSIS
Get Groups which user belongs

.PARAMETER UserName
username

.EXAMPLE
Get-BelongingGroups "testuser"

> @("Users", "Administrators")
#>

function Get-BelongingGroups {
  param(
    [parameter(Mandatory = $true)][string]$UserName
  )

  $Res = New-Object 'System.Collections.Generic.List[string]'
  $Groups = ((Get-WmiObject Win32_Groupuser) | Where-Object { $_.PartComponent -match $UserName }).GroupComponent
  if (!($GroupUser -is [array])) {
    $Res += $($Groups -replace '^\\\\.+",Name="', '') -replace '"$', ''
  }
  else {
    for ($i = 0; $i -lt $Groups.Length; $i++) {
      $Res += $($Groups[$i] -replace '^\\\\.+",Name="', '') -replace '"$', ''
    }
  }
  return $Res
}

<#
.SYNOPSIS
Test provided roles is in Groups

.PARAMETER Roles
Parameter description

.PARAMETER Groups
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>

function Test-RolesInGroups {
  param(
    [parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[string]]$Roles,
    [parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[string]]$Groups
  )
  $Res = 0
  foreach ($r in $Roles) {
    $Exist = $false
    foreach ($g in $Groups) {
      if ($r -eq $g) {
        $Res++
        $Exist = $true
        Write-Host "OK: $r Role is in Groups"
      }
    }
    if (!$Exist) {
      Write-Warning "$r role is not in Groups"
    }
  }
  if ($Groups.Count -eq $Res) {
    return $true
  }
  else {
    return $false
  }
}
Export-ModuleMember -Function Get-BelongingGroups, Test-RolesInGroups
