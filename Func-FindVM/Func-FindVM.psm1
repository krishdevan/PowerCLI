Function Find-VM {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$PartialVMName,
		[string[]]$ClassName
    )

	$vmObjects = @()
    $searchStr = "*$PartialVMName*"
	$vm        = Get-VM -Location $ClassName | 
				   where {$_.Name -like $searchStr}		
    
    $vm | Foreach {
		$obj = [PSCustomObject]@{
			'Name'        = $_.Name
			'PowerState'  = $_.PowerState
			'VMHost'      = $_.VMHost.Name
		}
	
		$vmObjects += $obj
	}
    Write-Output $vmObjects

}
#Find-VM