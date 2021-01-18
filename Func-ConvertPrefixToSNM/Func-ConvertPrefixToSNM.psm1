Function Convert-PrefixLengthToSNM
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,
        ValueFromPipeLine = $true)]
        [int]$PrefixLength = 24
    )
    BEGIN {
        [string]$Mask       = $null
        [string]$DottedMask = $null
    }

    PROCESS {
        1..$PrefixLength | Foreach {
            $Mask += "1"
        }

        $hostBits = 32 - $prefixLength
        1..$hostBits | foreach {
            $Mask += 0
        }
        [string]$DottedMask = $null
        [string]$DottedOctet = $null
        for($index = 0; $index -lt 32; $index++)
        {
            #$index
            if( ($index -ne 0) -and ( ($index % 8) -eq 0) )
            {
                $DottedMask += "." + $Mask[$index]
            }
            else
            {
                $DottedMask += $Mask[$index]
            }            
        }

        $octet = $DottedMask.Split('.')
        foreach($o in $octet)
        {
            $DottedOctet += Convert-BinaryToDecimal -Binary $o
            $DottedOctet += "."
        }

        $Prop            = [ordered]@{
            'Maskbits'   = $Mask
            'DottedMask' = $DottedMask
            'SubnetMask' = $DottedOctet
        }

    $obj = New-Object -TypeName PSObject -Property $prop
    }
    
    END
    {
        Write-Output $obj
    }

}





