<#
.Synopsis
   Aternity - PowerShell Health Event Monitor: Get time from reboot.  Raise events time > 7 days or 10 days ago
.DESCRIPTION
	Gets time since reboot and raise event if necessary
	
	References:
	* https://www.aternity.com
	* https://help.aternity.com/csh?Product=latest&topicname=admin_script_health_event.html
.EXAMPLE
#>

try
{
	# Load Agent Module
	Add-Type -Path $env:STEELCENTRAL_ATERNITY_AGENT_HOME\ActionExtensionsMethods.dll

	$boottime = Get-CimInstance -ClassName win32_operatingsystem | Select-Object LastBootUpTime
	
	$difference = New-Timespan -End $boottime.LastBootUpTime
	
	if ($difference.Days -le -10)
	{
		Write-Output "More than 10 days since last reboot"
		[ActionExtensionsMethods.PowershellPluginMethods]::SetEventOccurred()
		[ActionExtensionsMethods.PowershellPluginMethods]::SetComponentType("Timeframe")
		[ActionExtensionsMethods.PowershellPluginMethods]::SetComponent("More than 10 days since last reboot")
	}
	elseif ($difference.Days -le -7) {
		Write-Output "More than 7 days since last reboot"
		[ActionExtensionsMethods.PowershellPluginMethods]::SetEventOccurred()
		[ActionExtensionsMethods.PowershellPluginMethods]::SetComponentType("Timeframe")
		[ActionExtensionsMethods.PowershellPluginMethods]::SetComponent("More than 7 days since last reboot")
	}
}
catch
{
    [ActionExtensionsMethods.ActionExtensionsMethods]::SetFailed($_.Exception.Message)
}