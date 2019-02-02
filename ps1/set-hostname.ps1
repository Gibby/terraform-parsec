function Retry-Command {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        [scriptblock]$ScriptBlock,

        [Parameter(Position=1, Mandatory=$false)]
        [int]$Maximum = 30
    )

    Begin {
        $cnt = 0
    }

    Process {
        do {
            $cnt++
            try {
                $ScriptBlock.Invoke()
                return
				Start-Sleep 30
            } catch {
                Write-Error $_.Exception.InnerException.Message -ErrorAction Continue
            }
        } while ($cnt -lt $Maximum)

        # Restart computer after $Maximum unsuccessful invocations.
		Restart-Computer
    }
}

Retry-Command -ScriptBlock {

  $instanceid = (curl http://169.254.169.254/latest/meta-data/instance-id | Select Content ).Content
  $ec2_tag_hostname = (Get-EC2Tag -Filter @{Name="resource-id";Values="$instanceid"},@{Name="key";Values="Hostname"} | Select Value).Value
  if ($env:computername -ne $ec2_tag_hostname) {
    Rename-Computer -NewName "$ec2_tag_hostname" -Restart
  } else {
    Write-Output "Names match, do not need to rename server"
  }

}
