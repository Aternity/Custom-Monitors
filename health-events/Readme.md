# HEALTH Events 
Description of scripts or xml documents for retraival of custom data. 


###	Certificate Expires
	Description: Creates a health event when the device certificate is 7 days before expiration
	Technology:	Powershell Script
	Frequency:
###	Slow Outlook Plugins Boot Time	
	Description: Creates a health event whenever an Outlook’s addon launch takes more 5 sec during Outlook launch. The event also sends a contextual with the Addon name and the launch time. 	
	Technology:	Powershell Script
	Frequency:
###	Shutdown Restart By	
	Description: This event is written when an application causes the system to restart, or when the user initiates a restart or shut down by clicking Start or pressing CTRL+ALT+DELETE, and then clicking Shut Down. 	
	Technology:	Event Viewer
	Frequency:
### Driver Crash	
	Description: Alerts when a device is offline due to driver crash.  	
	Technology:	Event Viewer
	Frequency:
### Display Driver Crash	
	Description: 	  	
	Technology:	Event Viewer
	Frequency:
###	C Drive Bitlocker Status	
	Description: Creates a health event when the status on drive ‘C’ is not enable 	
	Technology:	WMI
	Frequency: 	1 Day
###	Disk Space Under X(GB)	
	Description: Give the option to decide when to alert low disk space 	
	Technology:	WMI
	Frequency: 	Hourly
###	DNS Queries Time out over IPv6	
	Description: Look for Events for DNS queries timeout of failed over DNS server queries with IPv6  	
	Technology:	Event Viewer / Windows Event logs
	Frequency: 	Every Minute
###	Pending Reboot Health Event	Powershell Script
	Description: Check for the registry entries on endpoint as well as check for WMI method for SCCM pending reboot flag  	
	Technology:	Powershell Script
	Frequency: 	will be controlled at the monitor tree level inside XML
###	Pending Reboot Health Event	Monitor XML
	Description: Create a monitor under device health bucket to check for Pending Reboot Flag  	
	Technology:	XML
	Frequency: 	case by case bases, based on your use case. Change the setting of frequency under <AgentConfiguration> parameter
###	No Recent Reboot Powershell Script
	Description: Create a health event when a device has not been rebooted in 7 or 10 days.  Component field gives the threshold that is breached, so that different Service Desk Alerts (SDAs) can be configured for each threshold.  Suggested SDA actions would be to prompt the user if they would like to reboot after 7 days before forcibly rebooting after 10 days.
	Technology:	Powershell Script
	Frequency: 	Will be controlled at the monitor tree level inside XML
###	No Recent Reboot Health Event Monitor XML
	Description: Create a monitor under device health bucket to check whether there has been no recent reboot. 	
	Technology:	XML
	Frequency: 	case by case bases, based on your use case.  Suggested timeframe is daily (86400000 ms). Change the setting of frequency under <AgentConfiguration> parameter
###	Last AD Connection Health Event	Powershell Script
	Description: Check when device was last connected to AD from Windows Event Logs and raise a health event if connection was more than 7 day ago  	
	Technology:	Powershell Script
	Frequency: 	Ideally check every couple of hours
###	Last AD Connection Health Event	Monitor XML
	Description: Create a monitor under device health bucket to check for Last AD Connection  	
	Technology:	XML
	Frequency: 	Ideally check every couple of hours
