
Function Open-Techvm {
    
    [CmdletBinding()]    
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("kdevan", "krish", "krishv")]
        $Login
    )

    $host.UI.RawUI.WindowTitle = $Login
    #$creds            = Get-VICredentialStoreItem -File $credFile
	$kdevanCreds       = Get-VICredentialStoreItem -User "tech\kdevan"
	$KDEVANConn        = @{		
		    'Server'   = $kdevanCreds.Host
	        'User'     = $kdevanCreds.User
			'Password' = $kdevanCreds.Password
	}
    
    $krishCreds        = Get-VICredentialStoreItem -User "tech\krish"
    $KRISHConn        = @{		
		    'Server'   = $krishCreds.Host
	        'User'     = $krishCreds.User
			'Password' = $krishCreds.Password
	}
	
	$krishvSphere      = Get-VICredentialStoreItem -User "krish@vsphere.local"
    $KRISHConnV        = @{		
		    'Server'   = $krishvSphere.Host
	        'User'     = $krishvSphere.User
			'Password' = $krishvSphere.Password
	}

    if ($Login -eq "kdevan")
    {
        Connect-VIServer @KDEVANConn
    }
    elseif ($Login -eq "krish")
    {
        Connect-VIServer @KRISHConn
    }
    else
    {
        Connect-VIServer @KRISHConnV
    }

}

Function Close-Techvm {
 
    Disconnect-VIServer -Server "techvm.greenriver.edu" -Confirm:$false	
}
