Function Update-VMConfig2 {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelinebyPropertyName=$True,
                   ValueFromPipeline=$true)]
                   [PSObject[]]$VMToBeConfigured        
    )

    BEGIN {
        
        $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        #$vmConfigSpec.ChangeVersion = $myVM.ExtensionData.Config.ChangeVersion

        $vmConfigSpec.BootOptions = New-Object VMware.Vim.VirtualMachineBootOptions    
        #Delay to boot up so that users can hit the F12 or Del key etc
        $bootDelayValue = "10000" # 10 seconds    
        $vmConfigSpec.BootOptions.BootDelay = $bootDelayValue
    
	    $vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
        $vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
	    $vmConfigSpec.Tools.SyncTimeWithHost = $true
				
		$vmConfigSpec.PowerOpInfo = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
		$vmConfigSpec.PowerOpInfo.StandbyAction = "checkpoint"
		
<#
        #copy/paste to/from VM options:
        $copy = New-Object VMware.Vim.OptionValue
	    $copy.Key="isolation.tools.copy.disable"
	    $copy.Value="FALSE"
	    $paste = New-Object VMware.Vim.OptionValue
	    $paste.Key="isolation.tools.paste.disable"
	    $paste.Value="FALSE"
        $vmConfigSpec.ExtraConfig += $copy
        $vmConfigSpec.ExtraConfig += $paste
#>  
        $ExtraOptions = @{
            "tools.syncTime"="1";
            "time.synchronize.continue"="0";
            "time.synchronize.restore"="0";
            "time.synchronize.resume.disk"="0";
            "time.synchronize.shrink"="0";
            "time.synchronize.tools.startup"="1";
            "isolation.tools.copy.disable"="FALSE"
            "isolation.tools.paste.disable"="FALSE"
        }   # build our configspec using the hashtable from above.

        Foreach ($Option in $ExtraOptions.GetEnumerator()) {
            $OptionValue = New-Object VMware.Vim.OptionValue
            $OptionValue.Key = $Option.Key
            $OptionValue.Value = $Option.Value
            $vmConfigSpec.ExtraConfig += $OptionValue
        }


    }

    PROCESS {
        foreach ($everyVM in $VMToBeConfigured) {
            Write-Host "`nChanging Config for $everyVM" -ForegroundColor Green
            $myVM = Get-VM -Name $everyVM | Get-View
            #Effect the changes made above into the VM...                        
            $myVM.ReconfigVM_Task($vmConfigSpec)
        } #foreach
    
    } #Process

} #end Function