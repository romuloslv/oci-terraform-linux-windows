$IPV4='${IPV4}'
$IQN='${IQN}'

Write-Output 'Configuring ISCSI service'
Set-Service -Name msiscsi -StartupType Automatic
Start-Service msiscsi

Write-Output 'Configuring ISCSI for Block Volumes'
New-IscsiTargetPortal -TargetPortalAddress $IPV4
Connect-IscsiTarget -NodeAddress $IQN -TargetPortalAddress $IPV4 -IsPersistent $True

Write-Output 'Configuring the new disk for a partition and file system'
Get-Disk -Number 1 | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "DATA" -Confirm:$false