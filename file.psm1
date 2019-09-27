function Backup-File {
  Param(
    [parameter(Mandatory)][String]$file
  )
  $now = Get-Date -format "yyyyMMddHHmmss"
  Copy-Item $file $file@$now -Force
}

# this method is like "sed". enable to use regexp.
function Update-Content {
  Param(
    [parameter(Mandatory)][string]$file,
    [parameter(Mandatory)][string]$beforeContent,
    [parameter(Mandatory)][string]$afterContent
  )
  $data = Get-Content $file | % { $_ -replace $beforeContent, $afterContent }
  $data | Out-String | % { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path $file -Encoding Byte
}

#Getting contents from file, then returns string array
function Get-LinesFromFile {
  Param (
    [parameter(Mandatory)][AllowEmptyString()][string]$PropertiesPath
  )
  if ([string]::IsNullOrWhiteSpace($PropertiesPath) -or !(Test-Path $PropertiesPath)) {
    return @()
  }
  else {
    return $(Get-Content -Path $PropertiesPath | Where-Object { $_.Trim() -ne '' }
    }
  }
}

# start logging. logfile is created at logs dir.
function Start-Logging {
  $Logname = ".\logs\ps_$(date -f yyyyMMddHHmmss).log"
  $Date = Get-Date -Format G
  try {
    Start-transcript $Logname
  }
  catch [System.Management.Automation.PSInvalidOperationException] {
    Write-Host "This powershell version is not implemented transcript function"
  }
}

# stop logging.
function Stop-Logging {
  try {
    Stop-transcript
  }
  catch [System.Management.Automation.PSInvalidOperationException] {
    Write-Host "This powershell version is not implemented transcript function"
  }
}

function Set-FullControl {
  Param(
    [parameter(Mandatory = $true)][String]$Dir,
    [parameter(Mandatory = $true)][String]$User
  )
  $acl = Get-Acl "$Dir"
  $permission = ("$User", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
  $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
  $acl.SetAccessRule($accessRule)
  $acl | Set-Acl "$Dir"
}

Export-ModuleMember -Function Backup-File, Update-Content, Get-LinesFromFile, Start-Logging, Stop-Logging, Set-FullControl
