<#
.Synopsis
   Similar to a println function
.DESCRIPTION
   Prints desired output in a desired color! The desired Colors are:
   Cyan, Yellow, Green, DarkCyan, DarkYellow, DarkGreen
   Default color is White.
.EXAMPLE
   Out-Log "Some Text" "Range of Colors"
#>
Function Out-Log {
    Param(
        [Parameter(Mandatory=$true)][string]$LineValue,
        [Parameter(Mandatory=$false)]
        [ValidateSet(
        "Green", "DarkGreen",
        "Yellow", "DarkYellow",
        "Cyan","DarkCyan",
        "Green","DarkGreen",
        "Magenta", "Red")]
        [string]$TextColor = "White"
    )
 
    #Add-Content -Path $logfile -Value $LineValue
    Write-Host $LineValue -ForegroundColor $TextColor
}
