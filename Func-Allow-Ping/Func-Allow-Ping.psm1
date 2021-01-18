Function Allow-Ping {
    New-NetFirewallRule -Name 'Allow-Ping' -DisplayName 'Pingy' `
        -Description "Ping ICMPv4" -Protocol ICMPv4 -IcmpType 8 `
        -Enabled True -Profile Any -Action Allow
}