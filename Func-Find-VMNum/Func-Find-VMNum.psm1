#GET THE GROUPS THEY BELONG TO USING WILDCARD
# SEARCH
Function Find-vmnum
{
[CmdletBinding()]
    param(
	[Parameter(Mandatory=$true)]          
        [string]$PartialName
    )
    #Clear-Host
    $csvFile      = Import-Csv "F:\Dropbox\GRCC\CLASSES\B782-VM-Roster.csv"
    $searchString = "*$PartialName*"
    
    $csvFile | where {$_.Name -like $searchString} | Foreach {
     out-log "VM Number of $($_.Name) is: $($_.VMNumber)" "Cyan" }          
}
