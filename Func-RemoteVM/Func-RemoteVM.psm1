<#
.Synopsis
   Remote in to a VM.
.DESCRIPTION
   This cmdlet opens a console to the VM using VMRC.The VM needs to be powered ON.
.EXAMPLE
   Remote-VM -VM NETLABs-VMWARE-ADMIN
.EXAMPLE
   Get-VM -Name NETLABs-VMWARE-ADMIN | Remote-VM
#>
function Remote-VM
{
    [CmdletBinding()]
    Param
    (
        # VM Name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$VMName
    )

    Begin
    {
        $sessionCount = $global:DefaultVIServer.RefCount
        if($sessionCount -lt 1)
        {
            Open-Techvm
        }
        $vms = Get-VM -Name $VMName
    }
    Process
    {
        foreach ($v in $vms)
        {
            # VM has to be ON to remote-console in
            if($v.PowerState -eq 'PoweredOff')
            { 
                Out-Log "`n*** Error: Cannot Remote to $($v.Name) because it is Powered Off" "Magenta"          
            }
            else
            {
                $v | Open-VMConsoleWindow
            }

        } #end foreach
    }
    End
    {
    }
} #end function

function Remote-VMFromList
{
    [CmdletBinding()]
    Param
    (
        # VM Name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$PartialVMName
    )

    Begin
    {
        $sessionCount = $global:DefaultVIServer.RefCount
        if($sessionCount -lt 1)
        {
            Open-Techvm
        }
        $searchStr = "*$PartialVMName*"
        $vms = Get-VM | where Name -Like $searchStr | ogv -PassThru
    }
    Process
    {
        foreach ($v in $vms)
        {
            # VM has to be ON to remote-console in
            if($v.PowerState -eq 'PoweredOff')
            { 
                Out-Log "`n*** Error: Cannot Remote to $($v.Name) because it is Powered Off" "Magenta"          
            }
            else
            {
                Out-Log "Remoting into $($v.Name)" "Green"
                $v | Open-VMConsoleWindow
            }

        } #end foreach
    }
    End {}
        
} #end function

function Remote-KrishVM
{
    [CmdletBinding()]
    Param
    (
        # VM Name
        [string]$VMName = "NETLABs-VMWARE-ADMIN"
    )

    Begin
    {
        $sessionCount = $global:DefaultVIServer.RefCount
        if($sessionCount -lt 1)
        {
            Open-Techvm
        }
        $vms = Get-VM -Name $VMName
    }
    Process
    {
        if($vms.PowerState -eq 'PoweredOff')
        { 
            Out-Log "`n*** Error: Cannot Remote to $VMName because it is Powered Off" "Magenta"          
        }
        else
        {
            Out-Log "Remoting into $VMName" "Green"
            $vms | Open-VMConsoleWindow
        }
        
    }
    End {}    
} #end function