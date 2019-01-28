C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeDisks.ps1

#Check for offline disks on server.
$offlinedisk = "list disk" | diskpart | where {$_ -match "offline"}

#If offline disk(s) exist
if($offlinedisk)
{

    Write-Output "Following Offline disk(s) found..Trying to bring Online."
    $offlinedisk

    #for all offline disk(s) found on the server
    foreach($offdisk in $offlinedisk)
    {

        $offdiskS = $offdisk.Substring(2,6)
        Write-Output "Enabling $offdiskS"
#Creating command parameters for selecting disk, making disk online and setting off the read-only flag.
$OnlineDisk = @"
select $offdiskS
attributes disk clear readonly
online disk
attributes disk clear readonly
"@
        #Sending parameters to diskpart
        $noOut = $OnlineDisk | diskpart
        sleep 5

   }

    #If selfhealing failed throw the alert.
    if(($offlinedisk = "list disk" | diskpart | where {$_ -match "offline"} ))
    {

        Write-Output "Failed to bring the following disk(s) online"
        $offlinedisk

    }
    else
    {

        Write-Output "Disk(s) are now online."

    }

}

#If no offline disk(s) exist.
else
{

    #All disk(s) are online.
    Write-Host "All disk(s) are online!"

}
