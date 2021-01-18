Function Get-IP
{
    $ipa = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = $true"           

    $Propv4 = [ordered]@{
        'IPv4Address'    = $ipa.IPAddress[0]
        'SubnetMask'     = $ipa.IPSubnet[0]
        'DefaultGateway' = $ipa.DefaultIPGateway[0]
        'MACAddress'     = $ipa.MACAddress
        'DNSServer'      = $ipa.DNSServerSearchOrder[0]
        'FQDN'           = $ipa.DNSHostName + "." + $ipa.DNSDomain
    }

    $Propv6 = [ordered]@{
        'IPV6Address'      = $ipa.IPAddress[1]
        'NetPrefix'        = $ipa.IPSubnet[1]
        'DefaultGateway'  = $ipa.DefaultIPGateway[1]
        'MACAddress'     = $ipa.MACAddress
        'DNSServer'      = $ipa.DNSServerSearchOrder[1]
        'FQDN'            = $ipa.DNSHostName + "." + $ipa.DNSDomain
    }

    $Obj4=New-Object -TypeName PSObject -Property $Propv4
    $Obj6=New-Object -TypeName PSObject -Property $Propv6

    Write-Output $Obj4, $Obj6
}