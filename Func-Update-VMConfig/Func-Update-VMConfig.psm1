Function Update-ClientVMConfig {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelinebyPropertyName=$True,
                   ValueFromPipeline=$true)]
                   [string]$UpdateConfigVM
    )
         
        $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        # $vmConfigSpec | gm -MemberType All

        #Delay to boot up so that users can hit the F12 or Del key etc
        $vmConfigSpec.BootOptions           = New-Object VMware.Vim.VirtualMachineBootOptions            
        $bootDelayValue                     = "5000" # 5 seconds    
        $vmConfigSpec.BootOptions.BootDelay = $bootDelayValue
    
	    # Disable VM Time Sync with Host
        $vmConfigSpec.Tools                  = New-Object VMware.Vim.ToolsConfigInfo        
	    $vmConfigSpec.Tools.SyncTimeWithHost = $false		

		# Win10 prevent putting VM into Suspend mode
        $vmConfigSpec.PowerOpInfo = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
        $vmConfigSpec.PowerOpInfo.StandbyAction = 'checkpoint'
		
        # Enable Copy/Paste from/To VM
        $copyObj       = New-Object VMware.Vim.OptionValue
        $copyObj.Key   = "isolation.tools.copy.disable"
        $copyObj.Value = "FALSE"

        $pasteObj       = New-Object VMware.Vim.OptionValue
        $pasteObj.Key   = "isolation.tools.paste.disable"
        $pasteObj.Value = "FALSE"        
				
        $vmConfigSpec.ExtraConfig += $copyObj
        $vmConfigSpec.ExtraConfig += $pasteObj
		$vmConfigSpec.ExtraConfig += $chipsetObj

        $vmView = Get-VM -Name $UpdateConfigVM | Get-View
        $vmView.ReconfigVM($vmConfigSpec)
        
} #end Function 'Update-VMConfig'
##################################################
Function Update-ServerVMConfig {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelinebyPropertyName=$True,
                   ValueFromPipeline=$true)]
                   [string]$UpdateConfigVM
    )
         
        $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        
        #Delay to boot up so that users can hit the F12 or Del key etc
        $vmConfigSpec.BootOptions           = New-Object VMware.Vim.VirtualMachineBootOptions            
        $bootDelayValue                     = "5000" # 5 seconds    
        $vmConfigSpec.BootOptions.BootDelay = $bootDelayValue
    
	    # Disable VM Time Sync with Host
        $vmConfigSpec.Tools                  = New-Object VMware.Vim.ToolsConfigInfo        
	    $vmConfigSpec.Tools.SyncTimeWithHost = $true		

        # Enable Copy/Paste from/To VM
        $copyObj       = New-Object VMware.Vim.OptionValue
        $copyObj.Key   = "isolation.tools.copy.disable"
        $copyObj.Value = "FALSE"

        $pasteObj       = New-Object VMware.Vim.OptionValue
        $pasteObj.Key   = "isolation.tools.paste.disable"
        $pasteObj.Value = "FALSE"        

        $vmConfigSpec.ExtraConfig += $copyObj
        $vmConfigSpec.ExtraConfig += $pasteObj

        <# Limit Snapshots to 2
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.ExtraConfig      += New-Object VMware.Vim.OptionValue
        $spec.ExtraConfig.Key   = "snapshot.maxSnapshots"
        $spec.ExtraConfig.Value = 2
        #>

        $vmView = Get-VM -Name $UpdateConfigVM | Get-View 
        $vmView.ReconfigVM($vmConfigSpec)
        
} #end Function 'Update-ServerVMConfig'

##################################################
Function Update-VMConfigNestedV {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelinebyPropertyName=$True,
                   ValueFromPipeline=$true)]
                   [string]$UpdateConfigVM
    )
        $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
		$vmConfigSpec.NestedHVEnabled = $true
        
        $vmConfigSpec.BootOptions           = New-Object VMware.Vim.VirtualMachineBootOptions    
        #Delay to boot up so that users can hit the F12 or Del key etc
        $bootDelayValue                     = "5000" # 5 seconds    
        $vmConfigSpec.BootOptions.BootDelay = $bootDelayValue
    
	    $vmConfigSpec.Tools                    = New-Object VMware.Vim.ToolsConfigInfo
        $vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
	    $vmConfigSpec.Tools.SyncTimeWithHost   = $true
				
		$vmConfigSpec.PowerOpInfo = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
		$vmConfigSpec.PowerOpInfo.StandbyAction = "checkpoint"

		# Enable Copy from/To VM
        $copyObj       = New-Object VMware.Vim.OptionValue
        $copyObj.Key   = "isolation.tools.copy.disable"
        $copyObj.Value = "FALSE"
		
		# Enable Paste from/To VM
        $pasteObj       = New-Object VMware.Vim.OptionValue
        $pasteObj.Key   = "isolation.tools.paste.disable"
        $pasteObj.Value = "FALSE"        
		
		# Autodetect svga
		$sVgaObj       = New-Object VMware.Vim.OptionValue
		$sVgaObj.Key   = "svga.autodetect"
		$sVgaObj.Value = "TRUE"
		
		$vmConfigSpec.ExtraConfig += $copyObj
		$vmConfigSpec.ExtraConfig += $pasteObj
		$vmConfigSpec.ExtraConfig += $sVgaObj
		            
		$vmView = Get-VM -Name $UpdateConfigVM | Get-View 
        $vmView.ReconfigVM($vmConfigSpec)      

} #end Function Update-VMConfigHyper-V