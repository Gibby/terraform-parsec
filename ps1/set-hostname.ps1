$instanceid = (curl http://169.254.169.254/latest/meta-data/instance-id | Select Content ).Content
$ec2_tag_hostname = (aws --region us-east-1 ec2 describe-instances --instance-ids "$instanceid" --query 'Reservations[*].Instances[*].[Tags[?Key==`Hostname`].Value]' --output=text)
if ($env:computername -ne $ec2_tag_hostname) {
  Rename-Computer -NewName "$ec2_tag_hostname" -Restart
}
