Function Get-VlanOnVM {

    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
                   [string]$VMName

    )
    Get-NetworkAdapter -VM $VMName | 
        select @{n="VM Name"; e={$_.Parent}},
        @{n="Vlan"; e={$_.NetworkName}},
        @{n="Adapter Name"; e={$_.Name}} | ft -AutoSize
      
}