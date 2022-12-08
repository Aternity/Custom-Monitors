try
{
    # Set new environment for Action Extensions Methods 
    Add-Type -Path $env:STEELCENTRAL_ATERNITY_AGENT_HOME\ActionExtensionsMethods.dll 
    #Use of Environment Module for user Profile
    $Localuserdata = "$env:LOCALAPPDATA"
    #setting the OST file location
    $OST_Location = "$Localuserdata\Microsoft\Outlook\"
    #$OST_file_count = Get-ChildItem $OST_Location\*.ost -Include *.ost -recurse | Measure-Object -property length -sum | select count | Format-list
    $OST_file_count = Get-ChildItem $OST_Location\*.ost -Include *.ost -recurse | Measure-Object -property length -sum | Select-Object -ExpandProperty count
    $OST_file_size_bytes = Get-ChildItem $OST_Location\*.ost -Include *.ost -recurse | Measure-Object -property length -sum | Select-Object -ExpandProperty sum
    $OST_file_size_GB = $OST_file_size_bytes * 0.000000001
    $OST_file_size_GB_Rounded=[math]::Round(($OST_file_size_GB),2)
    $OST_Count_Size = "OST File Count is " + $OST_file_count + " & size is " + $OST_file_size_GB_Rounded +" GB"
    #Adding Values to Custom Attribute 5
	[ActionExtensionsMethods.PowershellPluginMethods]::SetAttributeValueString("Custom Attribute 5",$OST_Count_Size)
}
catch
{
    [ActionExtensionsMethods.ActionExtensionsMethods]::SetFailed($_.Exception.Message)
}