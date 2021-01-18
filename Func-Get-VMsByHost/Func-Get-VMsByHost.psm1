<#
.Synopsis
   Get VMs on an ESXi host
.DESCRIPTION
   This cmdlet lets you get all the VMs that are created on the
   specified ESXi Host. 
.EXAMPLE
   Get-VMsByHost -VMHost techvm2.greenriver.edu

   This gets all the VMs that are on ESXi host called techvm2.greenriver.edu
.EXAMPLE
    techvm1.greenriver.edu | Get-VMsByHost
   
   This cmdlet get all the VMs on techvm1.greenriver.edu sent in
   via pipeline
#>
Function Get-VMsByHost {

    [CmdletBinding()]
    Param(

        #Parameter 1 - Host name Mandatory
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [ValidateSet("techvm1.greenriver.edu", 
                     "techvm2.greenriver.edu",
                     "techvm3.greenriver.edu",
					 "techvm6.greenriver.edu")]
        $VMHostName
    )
        WRite-host "This cmdlet will take a few seconds to run...`n" -f Yellow
		$vms    = (Get-VMhost $VMHostName | Get-View).VM |         
                  Get-VIObjectByVIView
        $vms    = $vms | sort Name
		write-output $vms
        $numVMs = $vms.Count
        "`nThere are $numVMs VMs on $VMHostName"
}