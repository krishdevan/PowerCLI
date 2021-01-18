<#
.Synopsis
   Retrieves the DNS name of the VM as seen by vCenter.
   Have to be connected to the vCenter before you can run this command.
.DESCRIPTION
   This command retrieves the FQDN of all the VMs in a VM Folder. This comes in 
   handy when you are installing a domain and have other servers joining the domain.
.EXAMPLE
   Get-VMsFQDN -ClassName IT240 -VMPartialName ServerDC1
.EXAMPLE
   IT240 | Get-VMFQDN -VMPartialName ServerDC1
#>
Function Get-VMFQDN
{
    [CmdletBinding()]        
    Param
    (
        # ClassName - aka VM Folder (Blue folder)
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [string]
        $ClassName,

        # VMPartialName - partial name of the interesting VMs
        [Parameter(ParameterSetName='Parameter Set 1')]
        [string]
        $VMPartialName
    )

    BEGIN
    {
        # initialize the collection
        $VMCollection = @()

        # Build the VM search string
        $vmStr  = "*" + $VMPartialName + "*"
    }

    PROCESS
    {         
        # Get the VMs in the requested folder
        $theVMS = Get-VM -Name $vmStr -Location $ClassName |
                    sort Name

        foreach ($t in $thevms)
        {
            # Build a custom object of the VM
            $vmObject = [PSCustomObject]@{
                Name = $t.Name
                FQDN = $t.Guest.HostName    
            }

            # Add it to the collection
            $VMCollection += $vmObject    
        }
    }

    END
    {
        # Display the collection
        Write-Output $VMCollection    
    }
} # end function
