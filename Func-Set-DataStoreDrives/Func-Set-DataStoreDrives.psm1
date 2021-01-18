   
<#
.Synopsis
    Maps Data Store Drives
.DESCRIPTION
    ALias names to map Datastore drives
.EXAMPLE
    Map-DataStoreDrive
#>
Function Set-DataStoreDrive {    
        
    Begin
    {
        #Datastore PSDrives
        $dts1 = Get-Datastore -Name NetAppVMs
        $dts2 = Get-Datastore -Name GoldMasters
        $dts3 = Get-Datastore -Name IsoImages
    }

    Process
    {
        #MAPPING NetAppVM Datastore
        if (!(Test-Path DSN:) )
	    {
		    New-PSDrive -Name DSN -PSProvider VimDatastore -Datastore $dts1 -Root "\" | Out-Null
	    }

        #MAPPING GoldMasters Datastore
	    if (!(Test-Path DSG:) )
	    {
		    New-PSDrive -Name DSG -PSProvider VimDatastore -Datastore $dts2 -Root "\" | Out-Null
	    }

        #MAPPING ISOImages Datastore
	    if (!(Test-Path DSI:) )
	    {
		    New-PSDrive -Name DSI -PSProvider VimDatastore -Datastore $dts3 -Root "\" | Out-Null
	    }
    }

    End
    {
        Write-Host "DSN: $(Test-Path DSN:) $($dts1.Name)"
        Write-Host "DSG: $(Test-Path DSG:) $($dts2.Name)"
        Write-Host "DSI: $(Test-Path DSI:) $($dts3.Name)"
    }    

}