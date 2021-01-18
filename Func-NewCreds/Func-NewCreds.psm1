Function New-Creds {

    # GENERATE A CREDENTIAL FILE CALLED CREDFILE.XML whenever 
    # you change your password.
    #
    # THIS XML IS LATER USED IN TECHVM-IN TO LOG INTO TECHVM
    # TECHVM-IN FUNCTION IS IN FuncConnectTechvm Module
   
	$vmhostName = "techvm.greenriver.edu"
	$user       = Read-Host "User Name"
	$password   = Read-Host "Enter clear-text Password"

    New-VICredentialStoreItem -Host $vmhostName -User $user -Password $password
	# Without the -File $credfile parameter, the above command 
	#    Creates the credfile in the following (default) location:
	# 	"C:\Users\krish\AppData\Roaming\VMware\credstore\vicredentials.xml"
    
}