# Get the OST file Size & Count in User's Outlook profiles

This Monitor is using Custom_attribute_5 to report the count & size in GB of OST files. 
Results will Appear in Tablue in format like this "OST File Count is x & size is x.xx GB" where x is numbers. 

# Create a Calculated Field in Tableau to extract as its individual measures. 

OST File Count = FLOAT(REGEXP_EXTRACT([Custom Attribute 5],'[Ost File Count is ]+(\d+)'))
OST FIle Size (GB) = FLOAT(REGEXP_EXTRACT([Custom Attribute 5],'[Size is ]+((\d+)\.(\d+))'))

