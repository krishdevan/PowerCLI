function New-ComplexPassword {
    [CmdletBinding()]
    param (
        [int]$PasswordLength = 16,
        [int]$SpecialCharacterCount = 5
    )
    
    begin {
        Add-Type -AssemblyName System.Web
        Write-Host "Generating complex Password" -ForegroundColor Cyan
    }
    
    process {
        # GeneratePassword static method: Generates a random password
        #  given password length and special char count
        $complexPassword = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $SpecialCharacterCount)
    }
    
    end {
        Write-Host "New complex password is: $complexPassword" -ForegroundColor Green
    }
}