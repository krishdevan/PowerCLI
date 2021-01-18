Function Get-VMsonVlan {

    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
                   [string]$VlanID

    )
    
    Get-VDPortgroup -Name $VlanID | Get-VM |
        select Name,
        @{n="Vlan"; e={$VlanID}},
        @{n="VMHostName"; e={$_.VMHost.Name } },
        @{n="PowerState"; e={$_.PowerState } }
    
    <#
	Write-Host "`nOn Templates..." -ForegroundColor Green
    Get-Template * | Foreach {
    $templateName = $_.Name    
    Get-NetworkAdapter -Template $_ | 
        where NetworkName -eq $VlanID |
            Select Name,
            @{n="Template"; e={$templateName}},
            @{n="Vlan"; e={$VlanID}}
    }
	#>
      
}