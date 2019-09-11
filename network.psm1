# check port is listening. if yes, return $true
function Test-TCPSocket {
  param(
    [parameter(mandatory)][string]$IPAddr,
    [parameter(mandatory)][int]$Port
   )
  $tc = New-Object System.Net.Sockets.tcpClient
  try {
    $tc.connect($IPAddr, $Port)
    $Res = $tc.Connected
  }
  catch [System.Management.Automation.MethodInvocationException] {
    Write-Debug "${IPAddr}:${Port} is not listening"
    return $false
  }
  finally {
    $tc.Close()
  }
  Write-Debug "${IPAddr}:${Port} is listening"
  return $true
}

Export-ModuleMember -Function Test-TCPSocket
