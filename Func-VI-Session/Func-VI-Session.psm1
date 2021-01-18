Function Get-ViSession {
<#
.SYNOPSIS
Lists vCenter Sessions.

.DESCRIPTION
Lists all connected vCenter Sessions.

.EXAMPLE
PS C:\> Get-VISession

.EXAMPLE
PS C:\> Get-VISession | Where { $_.IdleMinutes -gt 5 }
#>
$SessionMgr = Get-View $DefaultViserver.ExtensionData.Client.ServiceContent.SessionManager
$AllSessions = @()

$SessionMgr.SessionList | Foreach {
    $Session = New-Object -TypeName PSObject -Property @{
        Key = $_.Key
        UserName = $_.UserName
        FullName = $_.FullName
        LoginTime = ($_.LoginTime).ToLocalTime()
        LastActiveTime = ($_.LastActiveTime).ToLocalTime()

    }
    If ($_.Key -eq $SessionMgr.CurrentSession.Key) {
        $Session | Add-Member -MemberType NoteProperty -Name Status -Value “Current Session”
    } Else {
        $Session | Add-Member -MemberType NoteProperty -Name Status -Value “Idle”
    }

    $Session | 
        Add-Member -MemberType NoteProperty -Name IdleMinutes -Value ([Math]::Round(((Get-Date) – ($_.LastActiveTime).ToLocalTime()).TotalMinutes))
        $AllSessions += $Session
    } #foreach

$AllSessions
} #end function

Function Disconnect-ViSession {
<#
.SYNOPSIS
Disconnects a connected vCenter Session.

.DESCRIPTION
Disconnects a open connected vCenter Session.

.PARAMETER  SessionList
A session or a list of sessions to disconnect.

.EXAMPLE
PS C:\> Get-VISession | Where { $_.IdleMinutes -gt 5 } | Disconnect-ViSession

.EXAMPLE
PS C:\> Get-VISession | Where { $_.Username -eq “User19” } | Disconnect-ViSession
#>
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true)]
        $SessionList
    )

    Process {
        $SessionMgr = Get-View $DefaultViserver.ExtensionData.Client.ServiceContent.SessionManager
        $SessionList | Foreach {
            Write “Disconnecting Session for $($_.Username) which has been active since $($_.LoginTime)”
            $SessionMgr.TerminateSession($_.Key)
        }
    }#end Process{}
}#end Disconnect-VISession

<#
.Synopsis
   Remove Idle sessions
.DESCRIPTION
   This function removes sessions that have been logged on but has remained idle for a considerable amount of time.
   The user can determine to remove sessions that have been idle for greater than 2 days up to 5 days.
.EXAMPLE
   By default, the function removes all idle sessions greater than 2 days
   
   Remove-IdleSession
.EXAMPLE
   This example shows how to use this function to remove idle sessions greater than 3 days:

   Remove-IdleSession -Days 3
#>
Function Remove-IdleSession
{
    [CmdletBinding()]
    
    Param
    (
        # Number of days to be converted to minutes later
        [Parameter(ValueFromPipeline=$true)]
        [Alias("NumberOfDays", "IdleDays", "DaysIdle")]
        [int]$Days = 2
    )

    Begin
    {
        $logDir = "D:\Temp\Logs\"
	    $logfile = $logdir + "Log-" + (Get-Date -UFormat %Y-%m-%d_%M) + ".txt"
	    If (!(Test-Path $logDir)) 
		{
			New-Item -ItemType directory -Path $logDir | Out-Null
		}	

        # Add VMware snap-in if required
	    If ((Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) -eq $null)
        {
            Add-PSSnapin VMware.VimAutomation.Core
        }
		        
        $creds = Get-VICredentialStoreItem
        Connect-VIServer -Server $creds.Host -User $creds.User -Password $creds.Password -EA Stop |
            Out-Null
    } #end BEGIN
    
    Process
    {
        $numMinutes = 1440 * $Days
        Get-VISession | Where {$_.IdleMinutes -gt $numMinutes} | 
            Disconnect-ViSession | Out-File $logfile

        $activeSessions = (Get-ViSession).Count
        "`nThere are $activeSessions Active Sessions currently`n" | Out-File $logfile -Append
    } #end PROCESS

    End
    {        
        Disconnect-VIServer -Server $creds.Host -Force -Confirm:$false
        Remove-PSSnapin VMware.VimAutomation.Core   
    }
} #end Remove-IdleSession