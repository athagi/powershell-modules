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
Export-ModuleMember -Function Test-DisableTurnOffHardDisk, Test-DisableHybernate, Test-DisableSleep
