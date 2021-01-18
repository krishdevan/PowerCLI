Function Get-VMwaretoolStats {

    [CmdletBinding()]
    param(
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true)]
        $Folder
        )

    Get-VM -Location $Folder | Get-View | 
        Select @{N="VM Name"; E={$_.Name} },
               @{N="VMware Tools"; E={$_.Guest.ToolsStatus} } 
}