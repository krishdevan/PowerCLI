Function Check-VMPowerState {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$ClassName
    )

    $vmsOn = Get-VM -Location $ClassName |
                    where {$_.PowerState -eq 'PoweredOn'}
    
    if($vmsOn -ne $null) {          
	    $vmsOn | select Name, PowerState | Format-Table -AutoSize
    }

}