<#
.Synopsis
   Shut down the guest os of a VM.
.DESCRIPTION
   This cmdlet shuts down the operating system of the guest VM.   
.EXAMPLE
   ShutDown-VM -VM $vm
.EXAMPLE
   $VM | Shutdown-VM
#>
Function ShutDowm-VM
{
    [CmdletBinding()]    
    Param
    (
        # Mandatory Parameter - Name of the VM
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]                   
        $VMname
    )

    Begin
    {
        $vm = Get-VM $VMname | sort Name
    }
    Process
    {
        foreach($v in $vm)
        {
            if($v.PowerState -eq "PoweredOn")
            {
                Stop-VMGuest -VM $v -Confirm:$false
            }
            Get-VM $V | select Name, PowerState | ft -AutoSize
        }
    }
    End
    {
        "Exiting`n"
    }
}

