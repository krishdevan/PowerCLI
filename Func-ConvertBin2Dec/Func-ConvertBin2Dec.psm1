<#
.Synopsis
   COnvert a binary octet to its decimal equivalent
.DESCRIPTION
   This function takes a binary number (an octet of 8 bits) and
   returns the decimal equivalent of that binary
.EXAMPLE
   ConvertTo-Decimal 11001010
.EXAMPLE
   ConvertTo-Decimal -Binary 11001010
.EXAMPLE
     11001010 | ConvertTo-Decimal
.INPUTS
   Excepts a mandatory octet of bits
.OUTPUTS
   outputs the decimal equivalent of input binary
#>

Function Convert-BinaryToDecimal
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [ValidateLength(8,8)]
        [string]$Binary
    )
    
    $octet = @(128,64,32,16,8,4,2,1)    
    $decimal = 0

    for($index=0; $index -le 7; $index++)
    {   
        #Note the ' ' around 0. That represents a character
        #  Double quotes represents string
        #  characters can't participate in math calculations
        #  Had to create another variable $bit, and use that instead
        if($binary[$index] -eq '0')
        {
            $bit = 0
        }
        else
        {
            $bit = 1
        }
    
        $decimal += $octet[$index] * $bit
    }
	<#
	$property     = @{
		'Decimal' = $decimal
	}
	
	$obj = New-Object -TypeName System.Int32 -Property $property
	#>
    Write-Output $decimal
}


