$user='${user}'
$pass='${pass}'
$computerName='${host}'

Write-Output "Changing $user password"
net user $user $pass

Write-Output "Configuring WinRM"
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

Write-Output "Self-signed SSL certificate generated with details: $cert"
$cert = New-SelfSignedCertificate -CertStoreLocation 'Cert:\LocalMachine\My' -DnsName $computerName

$valueSet = @{
    Hostname = $computerName
    CertificateThumbprint = $cert.Thumbprint
}

$selectorSet = @{
    Transport = "HTTPS"
    Address = "*"
}

$listeners = Get-ChildItem WSMan:\localhost\Listener
If (!($listeners | Where {$_.Keys -like "TRANSPORT=HTTPS"}))
{
    Remove-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorSet
}

Write-Output "Enabling HTTPS listener"
New-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorSet -ValueSet $valueSet