Function Move-VM2VMDSFolder
{
    # Parameters
    param (
        [parameter(Mandatory=$true)]
        [string]$ClassName,
        [parameter(Mandatory=$true)]
        [string]$VMName
        )

    BEGIN
    {                
        #Datastore PSDrives
        $dts1 = Get-Datastore -Name NetAppVMs
        <#
		if (!(Test-Path DSN:) )
		{
			New-PSDrive -Name DSN -PSProvider VimDatastore -Datastore $dts1 -Root "\"
		}
        #>
        $netAppVmDrive = $dts1.DatastoreBrowserPath

        #Create DS VM Folder
        $dsVMfolder = "$netAppVmDrive\$ClassName\"
        
        if(!(Test-Path $dsVMfolder))
        {
            New-Item -ItemType Directory $dsVMfolder
        } 
        
           
    }#End BEGIN

    PROCESS
    {
        $VM2Move = get-vm -Location $ClassName -Name $VMName
        $VMHost = $VM2Move.VMHost

        #Remove VM from just the inventory.
        #Write-Host "Removing $VM2Move from inventory ..." -f Cyan
        Remove-VM -VM $VM2Move -Confirm:$false

        #Move VM files to new desired location ...
        #Write-Host "Moving files to new location for $VM2Move ..." -f Cyan
        Move-Item -Path "$netAppVmDrive\$VMName" -Destination $dsVMfolder

        #Establish path to register VM
        $vmfilepath = "[NetAppVMs] $className\$VMName\$VMName.vmx"

        #Write-Host "Adding $VM2Move back into inventory ..." -f Yellow  
        New-VM -VMFilePath $vmfilepath -VMHost $VMHost -Location $className
    
    }#END PROCESS

    END
    {
        Write-Host "VM Files Relocated ..." -f Green
    }
}
###############################################################
Function Move-VMToDatastoreFolder
{
    # Parameters
    param (
        [parameter(Mandatory=$true)]
        [string]$ClassName,
        [parameter(Mandatory=$true)]
        [VMware.VimAutomation.ViCore.Types.V1.Inventory.VirtualMachine]$VM
        )

    BEGIN
    {                        
		$VMname = $($VM.Name)
        $netAppVmDrive = $(Get-Datastore -Name NetAppVMs).DatastoreBrowserPath

        #Create DS VM Folder
        $dsVMfolder = "$netAppVmDrive\$ClassName\"
        
        if(!(Test-Path $dsVMfolder))
        {
            New-Item -ItemType Directory $dsVMfolder
        } 
        
           
    }#End BEGIN

    PROCESS
    {        
        $VMHost = $VM.VMHost

        #Remove VM from just the inventory.
        #Write-Host "Removing $VM2Move from inventory ..." -f Cyan
        Remove-VM -VM $VM -Confirm:$false

        #Move VM files to new desired location ...
        #Write-Host "Moving files to new location for $VM2Move ..." -f Cyan
        Move-Item -Path "$netAppVmDrive\$VMName" -Destination $dsVMfolder

        #Establish path to register VM
        $vmfilepath = "[NetAppVMs] $className\$VMName\$VMName.vmx"

        #Write-Host "Adding $VM2Move back into inventory ..." -f Yellow  
        New-VM -VMFilePath $vmfilepath -VMHost $VMHost -Location $className
    
    }#END PROCESS

    END
    {
        Write-Host "VM Files Relocated ..." -f Green
    }
}