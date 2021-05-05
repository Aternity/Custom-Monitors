# Aternity custom monitor script to find out how long ago devices have been connected to AD.

## Remote Workforce is a new norm these days. Workforce needs to connect to active directory via VPN to get all the necessary security patches and other critical updates from corporate domain to be in compliance. Aternity will help identify the devices by providing the last connection date and duration.  

* Use this script to analyze how many devices are not connected to domain for certain period of time.

## How to pupulate data within device attributes

* Aternity allows to use Custom Attributes upto 9 (1-9) to use this information captures aginst device attributes. Use custom attributes setup within script.

~~~ps1
ActionExtensionsMethods.PowershellPluginMethods]::SetAttributeValueString("Custom Attribute X",<Variable>)
~~~

* Use script as is to populate data with Market, Image Build Number, LOB, & Channel. Aternity provides ability to use other available attributes to choose from.
		
~~~xml 
<staticAttributes>
	<staticAttribute agentPluginName="Last VPN Connection Status" isGlobal="true" uiName="Market"/>
	<staticAttribute agentPluginName="Days Since Last Connected" isGlobal="true" uiName="Image Build Number"/>
	<staticAttribute agentPluginName="Last VPN Connection Date" isGlobal="true" uiName="LOB"/>
	<staticAttribute agentPluginName="Last Connection to VPN Period in Hours" isGlobal="true" uiName="Channel"/>
</staticAttributes>}
~~~

#### Reference: How to Define Custom Attributes https://help.aternity.com/bundle/console_admin_guide_2021x_console_saas/page/console/topics/console_admin_custom_data.html