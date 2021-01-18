<#
.Synopsis
    This script turns off VMs in a folder

.DESCRIPTION
    This script will turn off VMs inside a specified container by terminating the process running on the ESXi host.
	
    The different VMs we have are created in their respective class folders. For example,
    all the VMs for class IT385 are inside the folder IT385. This is the "Location" paramter's value. 
	
.EXAMPLE
   Turnoff-VM IT385

   This command will turn off all the VMs that are Powered on in the "IT385" folder. 

#>
Function Turnoff-VM
{
    [CmdletBinding()]    
    Param
    (
        # The location of the VM
        [Parameter(Mandatory=$true)]                 
        [String]$Foldername
    )

    #Get-VM -Location "KRISH-VMS" | Stop-VM -Confirm:$false
    Get-VM -Location $foldername | 
        where {$_.PowerState -eq 'PoweredOn'} | 
            Stop-VM -Kill -Confirm:$false
}