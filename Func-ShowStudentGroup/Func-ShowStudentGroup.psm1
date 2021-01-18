<#
.Synopsis
   Display the Group and Student assigned to the group.
.DESCRIPTION
   Each student is assigned to a VM through an AD Group that are created
   for each class, such as IT114_01, IT114_02 etc.
   This function will display each group and its assigned student name
.EXAMPLE
   Show-StudentGroup -Classname IT114
.EXAMPLE
   Show-StudentGroup IT114
#>
Function Show-StudentGroup 
{
    [CmdLetBinding()]
    Param
    (
        # Class Name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]              
        [string]$ClassName,

        # Optionally start at a specific value, def = 1,
        # i.e. start at the beginning
        [int]$GroupStart = 1,

        # Optionally limit at a specific value, def = 0,
        # i.e., go to the end
        [int]$GroupEnd = 0
    )
    # Build the AD Group Name
    $searchStr = "$className" + "_*"

    # Get the number of groups matching the criteria
    $groupCount = (Get-ADGroup -Filter {Name -like $searchStr}).Count
    
    if ($GroupEnd -eq 0)
    {
        $GroupEnd = $groupCount - 1
    }

    # Build a collection of retrieved group object to output
    $result = @()

    $GroupStart..$GroupEnd | foreach {
        $x          = "{0:D2}" -f $_
        $group      = "$classname" + "_$x"
        $vmNum      = "$classname" + "-VM#_" + $x
        $userName   = $group | Get-ADGroupMember | select -ExpandProperty Name
        $userId     = $group | Get-ADGroupMember | select -ExpandProperty samaccountname

        $displayDetails = [PSCustomObject]@{
            'VM_Num'      = $vmNum
            'StudentName' = $userName
            'Login'       = $userId
        }
        # Add to the collection
        $result += $displayDetails        
    }
    # Display the collection
    Write-Output "`n================================="
    Write-Output "Results for class: $className" 
    Write-Output "=================================" 
    Write-Output $result | Format-Table

} #end function