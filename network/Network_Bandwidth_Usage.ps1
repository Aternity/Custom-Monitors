<#
.Synopsis
   Aternity - Custom Health Data: Determine Network Bandwith % Used
.DESCRIPTION
	Determine individual values for key metrics and determine aggregated score from individual values.
	
.EXAMPLE
   Deploy as Aternity Powershell Monitor 
   Data can then be visualized in Custom Health Dashboard or Custom Health API
   Script is run once per minute 
#>

#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#add-type @"
#  using System.Net;
#  using System.Security.Cryptography.X509Certificates;
#  public class TrustAllCertsPolicy : ICertificatePolicy {
#      public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate,
#                                        WebRequest request, int certificateProblem) {
#          return true;
#      }
#   }
#"@

#[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

# Script to get Customer End User ISP Name
try
{
	# Set new environment for Action Extensions Methods
	Add-Type -Path $env:STEELCENTRAL_ATERNITY_AGENT_HOME\ActionExtensionsMethods.dll
	#Get-Bandwidth.ps1
	# Measure the Network interface IO over a period of 15 seconds (0.25)

	$startTime = get-date
	$endTime = $startTime.addMinutes(0.25)
	$timeSpan = new-timespan $startTime $endTime

	$count = 0
	$totalBandwidth = 0
	$lastresult = 0
    $maxresult = 0

	while ($timeSpan -gt 0)
	{
		# Get an object for the network interfaces, excluding any that are currently disabled.
		$colInterfaces = Get-WmiObject -class Win32_PerfFormattedData_Tcpip_NetworkInterface |select BytesTotalPersec, CurrentBandwidth,PacketsPersec|where {$_.PacketsPersec -gt 0}
		foreach ($interface in $colInterfaces) {
			$bitsPerSec = $interface.BytesTotalPersec * 8
			$totalBits = $interface.CurrentBandwidth
            # Store the highest result in a variable for a max usage sample
			# Exclude Nulls (any WMI failures)
			if ($totalBits -gt 0) {
				$result = (( $bitsPerSec / $totalBits) * 100)
             	if ($result -gt $lastresult) {
				$maxresult = $result
                }
				$lastresult = $result
				$totalBandwidth = $totalBandwidth + $result
				$count++
			}
		}
		Start-Sleep -milliseconds 100
		# recalculate the remaining time
		$timeSpan = new-timespan $(Get-Date) $endTime
	}
	$averageBandwidth = $totalBandwidth / $count
	$result = "{0:N2}" -f $averageBandwidth
	# [ActionExtensionsMethods.PowershellPluginMethods]::SetEventOccurred()
	[ActionExtensionsMethods.PowershellPluginMethods]::SetAttributeValueString("PluginMonitored1","$result")
	[ActionExtensionsMethods.PowershellPluginMethods]::SetAttributeValueString("PluginMonitored2","$totalBits")
	[ActionExtensionsMethods.PowershellPluginMethods]::SetAttributeValueString("PluginMonitored3","$maxresult")
}
catch
{
	[ActionExtensionsMethods.ActionExtensionsMethods]::SetFailed($_.Exception.Message)
}
