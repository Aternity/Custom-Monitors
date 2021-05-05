<#
.Synopsis
   Check when device was last connected to AD from Windows Event Logs and raise a health event. 
.DESCRIPTION
	Looking at windows event logs to find out what was the last connection from Device to a Corp Domain (from Regirsty). If device was not connected for more than 7 days then register health event. 
#>
Try
{
	#Set new environment for Action Extensions Methods 
    Add-Type -Path $env:STEELCENTRAL_ATERNITY_AGENT_HOME\ActionExtensionsMethods.dll
	#Set Domain
    $domain = Get-ItemPropertyValue -path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\' -name Domain
    # Silently Connect to domain
    If ((Get-WmiObject Win32_OperatingSystem).Version -like "*10.0*") {
        $ConnectedNow = (Test-NetConnection $domain -Port 636).TcpTestSucceeded
    } Else {
        $ConnectedNow = Test-Connection $domain -quiet
    }
	#Grab Last Conencted date from event Log with Timespan
	$EvLogLastConnect = (Get-WinEvent -logname "Microsoft-Windows-NetworkProfile/Operational" |where-object {$_.ID -eq "10000"} |Where-Object {$_.message -like "*Domain Authenticated*"} |Group-object ID |Foreach-Object {$_.Group | Sort-Object TimeCreated | Select-Object -Last 1}).TimeCreated |New-TimeSpan
	#Grab Last Conencted date from event Log for actual Date
	$EvLogLastConnectDate = (Get-WinEvent -logname "Microsoft-Windows-NetworkProfile/Operational" |where-object {$_.ID -eq "10000"} |Where-Object {$_.message -like "*Domain Authenticated*"} |Group-object ID |Foreach-Object {$_.Group | Sort-Object TimeCreated | Select-Object -Last 1}).TimeCreated

	If ($ConnectedNow -eq $False)
	{
		#Grab Last Disconnected Date from event log with Timespan
		$EvLogLastDisConn = (Get-WinEvent -logname "Microsoft-Windows-NetworkProfile/Operational" |where-object {$_.ID -eq "10001"} |Where-Object {$_.message -like "*Domain Authenticated*"} |Group-object ID |Foreach-Object {$_.Group | Sort-Object TimeCreated | Select-Object -Last 1}).TimeCreated|New-TimeSpan
		#Grab Last Disconnected date from Event Log for actual Date
		$EvLogLastDisConnDate = (Get-WinEvent -logname "Microsoft-Windows-NetworkProfile/Operational" |where-object {$_.ID -eq "10001"} |Where-Object {$_.message -like "*Domain Authenticated*"} |Group-object ID |Foreach-Object {$_.Group | Sort-Object TimeCreated | Select-Object -Last 1}).TimeCreated
		If ($EvLogLastDisConn.TotalHours -lt $EvLogLastConnect.TotalHours)
		{
			$ConnectionPeriod = [math]::round($EvLogLastConnect.TotalHours - $EvLogLastDisConn.TotalHours,2)
			$VPNConnectionDateTime = "This device was connected to domain for period of $ConnectionPeriod Hours. Last connection to $domain domain was at $EvLogLastConnectDate"
			$DaysSinceLastConnected = [math]::round($EvLogLastDisConn.TotalDays,2)
		}
		else 
		{
			$VPNConnectionDateTime = "Eventlogs do not indicate period online, perhaps device not gracefully shutdown."
			$ConnectionPeriod = 0
			$DaysSinceLastConnected = [math]::round($EvLogLastConnect.TotalDays,2)
		}
	} 
	else 
	{
		$ConnectionPeriod = [math]::round($EvLogLastConnect.TotalHours,2)
		$VPNConnectionDateTime =  "This device has been connected to domain for period of $ConnectionPeriod Hours. Last connection to $Domain domain was at $EvLogLastConnectDate"
		$DaysSinceLastConnected = 0
	}
    #Write-Host $DaysSinceLastConnected
    if ( $DaysSinceLastConnected -gt "7.00" )
    {
        $HealthEvent = "Last AD Connection was " + $DaysSinceLastConnected + " days ago."
        #Write-Host $HealthEvent
        [ActionExtensionsMethods.PowershellPluginMethods]::SetComponent("System")
        [ActionExtensionsMethods.PowershellPluginMethods]::SetDetails($HealthEvent)
        [ActionExtensionsMethods.PowershellPluginMethods]::SetSubComponent("Operation System")
        [ActionExtensionsMethods.PowershellPluginMethods]::SetEventOccurred()
    }
    else
    {
        #Do not register health event
    }
}

catch 
{
	[ActionExtensionsMethods.ActionExtensionsMethods]::SetFailed($_.Exception.Message)
}