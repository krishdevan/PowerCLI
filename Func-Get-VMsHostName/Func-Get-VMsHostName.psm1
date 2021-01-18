<#
.Synopsis
   Retrieve the ESXi host that this VM is on.
.DESCRIPTION
   This function retrieves the name of the ESXi host that this VM is currently
   standing on.
.EXAMPLE
   Get-VMsHost -VM IT240-ServerDM2-01
.EXAMPLE
   Get-VMsHost -VM "IT240-ServerDM2-01", "IT240-Router-09"
.OUTPUTS
   Names of the hosts
#>
function Get-VMsHostName
{
    [CmdletBinding()]    
    Param
    (
        # An array of VM names
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true)]
        [string[]]
        $VM
    )

    Begin
    {
        $VMCollection = @()                 
    }

    Process
    {
        foreach ($v in $VM)
        {
            $vmname = Get-VM $v
            $na     = Get-NetworkAdapter -VM $vmname                        
            $VMObject       = [PSCustomObject]@{
                Name        = $vmname.Name
                Host        = $vmname.VMHost.Name
                State       = $vmname.PowerState
                NetAdapters = $na
            } #end hashtable

            $VMCollection += $VMObject
        } # end foreach vm    
    }
    End
    {
        Write-Output $VMCollection
    }
} # end function