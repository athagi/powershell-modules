function Test-DisableTurnOffHardDisk {
  param(
    [string]$SchemeGUID
  )
  $Val = (powercfg /Q $SchemeGUID SUB_DISK DISKIDLE | Select-String " AC ") -replace ".* AC .*: ", ""
  if ($Val -eq "0x00000000") {
    return $true
  }
  else {
    return $false
  }
}

function Test-DisableHybernate {
  param(
    [string]$SchemeGUID
  )
  $Val = (powercfg /Q $SchemeGUID SUB_SLEEP HIBERNATEIDLE | select-string " AC ") -replace ".* AC .*: ", ""
  if ($Val -eq "0x00000000") {
    return $true
  }
  else {
    return $false
  }
}

function Test-DisableSleep {
  param(
    [string]$SchemeGUID
  )
  $Val = (powercfg /Q $SchemeGUID SUB_SLEEP STANDBYIDLE | select-string " AC ") -replace ".* AC .*: ", ""
  if ($Val -eq "0x00000000") {
    return $true
  }
  else {
    return $false
  }
}

function Get-CurrentPowerPlan {
  $Scheme = @{
    "SCHEME_MAX"      = "a1841308-3541-4fab-bc81-f71556f20b4a";
    "SCHEME_BALANCED" = "381b4222-f694-41f0-9685-ff5bb260df2e";
    "SCHEME_MIN"      = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
  }
  $Mode = powercfg.exe /GETACTIVESCHEME
  foreach ($k in $Scheme.Keys) {
    if ($Mode -cmatch $Scheme[$k]) {
      return $k
    }
  }
}

Export-ModuleMember -Function Test-DisableTurnOffHardDisk, Test-DisableHybernate, Test-DisableSleep, Get-CurrentPowerPlan
