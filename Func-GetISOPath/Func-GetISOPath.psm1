Function Get-IsoImagesISOPath {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            "Server-2012-R2",
			"Server-2016",
            "Windows-7",            
            "Windows-10",                        
			"Fedora-Latest",
			"Ubuntu-Latest",
            "Kali-Linux",
			"RHEL")]
            [string]$OS
    )
    
    [hashtable]$returnValues = @{}
    #region - OS Choices Menu: W7, W10, and Linux   
    
    $isoimagesPathName = "vmstores:\techvm.greenriver.edu@443\Virtuals\IsoImages"

    Switch ($OS) {
        "Server-2012-R2" {            
                $guestId = "windows8Server64Guest"
                #$isoPath = "[IsoImages] SERVER_2012_R2/SERVER_EVAL_W_VMTOOLS6U2.ISO"
                $isoPath = "[IsoImages] SERVER_2012_R2/SERVER_2012_R2_EVAL.ISO"
                break
        }"Server-2016" {            
                $guestId = "windows9Server64Guest"
                #$isoPath = "[IsoImages] SERVER_2016/Server2K16_VMTools.iso"
                $isoPath = "[IsoImages] SERVER_2016/SERVER_2016_EVAL.iso"
                break     
        } "Windows-7" {                                                   
                $guestId = "windows7_64Guest"            
                $isoPath = "[IsoImages] WINDOWS_7/win7_ent_sp1_x64_VMTOOLS6U2.iso"
                break            

        } "Windows-10" {               
                $guestid = "windows9_64Guest"
                #$isoPath = "[IsoImages] WINDOWS_10/WIN10-1607-ENT-EVAL_VMTOOLS6U2.ISO"
                $isoPath = "[IsoImages] WINDOWS_10/WIN10-ENT-EVAL_X64.ISO"
                break            

        } "Fedora-Latest" {            
                $guestid = "other3xLinux64Guest"
                $isopath = "[IsoImages] Linux/FedoraLatest/Fedora-WS.iso"
                break

        } "Ubuntu-Latest" {            
                $guestid = "other3xLinux64Guest"
                $isopath = "[IsoImages] Linux/UbuntuLatest/ubuntu-WS.iso"
                break
                    
        } "Kali-Linux" {             
                $guestid = "other3xLinux64Guest"
                $isopath = "[IsoImages] Linux/kali-linux-2018.1-amd64.iso"
                break
            
        } "pfSense" {            
                $guestid = "freebsd64Guest"
                $isopath = "[IsoImages] Firewalls/pfSense-LiveCD-2.2.6-RELEASE-amd64.iso"
                break
        } "RHEL" {
				$guestid = "rhel7_64Guest"
				$isopath = "[IsoImages] Linux/rhel-server-7.4-x86_64-dvd.iso"
		}    
    }
#endregion
$returnValues.GuestID = $guestId
$returnValues.IsoPath = $isoPath
return $returnValues

}

