C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
$instanceid = (curl http://169.254.169.254/latest/meta-data/instance-id | Select Content ).Content
$ec2_tag_hostname = (Get-EC2Tag -Filter @{Name="resource-id";Values="$instanceid"},@{Name="key";Values="Hostname"} | Select Value).Value
if ($env:computername -ne $ec2_tag_hostname) {
  Rename-Computer -NewName "$ec2_tag_hostname" -Restart
}
