
$CryptoScanner_Load={
	Import-Module ActiveDirectory
	$Machines = Get-ADComputer -Filter 'ObjectClass -eq "Computer"'
	Load-ComboBox $combobox_Server $Machines.Name -ErrorAction SilentlyContinue
	$textbox_Extension.ShortcutsEnabled = $True
	$combobox_Server.Sorted = $True
}

$button_Run_Click = {
	$SearchServer = $combobox_Server.Text
	$Extension = $textbox_Extension.Text
	If ($radiobuttonCSV.Checked)
	{
		$button_Run.Enabled = $False
		$Results = $SearchServer | ForEach-Object{
			Invoke-Command -ComputerName $SearchServer -scriptblock {
				Get-WmiObject win32_logicaldisk -filter "DriveType = 3" | Select-Object DeviceID |
				Foreach-Object {
					Get-Childitem ($_.DeviceID + "\") -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {($_.PSIsContainer -eq $false) -and ($_.Name -like "*$Using:Extension*") -and ($_.Name -notlike "*.lnk") }
				} | Select-Object Name, Directory, @{ Name = "Kilobytes"; Expression = { "{0:N0}" -f ($_.Length / 1Kb) } }, @{ Name = "File Owner"; Expression = { (Get-Acl $_.FullName).Owner } } | Export-CSV -Path "C:\CryptoScan_$using:SearchServer.csv" -NoTypeInformation
			}
		}
		$button_Run.Enabled = $True
	}
	Elseif ($radiobuttonHTML.Checked)
	{
		$button_Run.Enabled = $False
		$Results = $SearchServer | ForEach-Object{
			Invoke-Command -ComputerName $SearchServer -scriptblock {
				Get-WmiObject win32_logicaldisk -filter "DriveType = 3" | Select-Object DeviceID |
				Foreach-Object {
					Get-Childitem ($_.DeviceID + "\") -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and ($_.Name -like "*$Using:Extension*") -and ($_.Name -notlike "*.lnk") }
				} | Select-Object Name, Directory, @{ Name = "Kilobytes"; Expression = { "{0:N0}" -f ($_.Length / 1Kb) } }, @{ Name = "File Owner"; Expression = { (Get-Acl $_.FullName).Owner } } | ConvertTo-HTML | Out-File "C:\CryptoScan_$using:SearchServer.htm"
			}
		}
		$button_Run.Enabled = $True
	}
	Else
	{
		[System.Windows.Forms.MessageBox]::Show("$_", "Error")
	}
}


$buttonExit_Click={
	$CryptoScanner.close()
}


#region Control Helper Functions
function Load-ComboBox 
{
<#
	.SYNOPSIS
		This functions helps you load items into a ComboBox.

	.DESCRIPTION
		Use this function to dynamically load items into the ComboBox control.

	.PARAMETER  ComboBox
		The ComboBox control you want to add items to.

	.PARAMETER  Items
		The object or objects you wish to load into the ComboBox's Items collection.

	.PARAMETER  DisplayMember
		Indicates the property to display for the items in this control.
	
	.PARAMETER  Append
		Adds the item(s) to the ComboBox without clearing the Items collection.
	
	.EXAMPLE
		Load-ComboBox $combobox1 "Red", "White", "Blue"
	
	.EXAMPLE
		Load-ComboBox $combobox1 "Red" -Append
		Load-ComboBox $combobox1 "White" -Append
		Load-ComboBox $combobox1 "Blue" -Append
	
	.EXAMPLE
		Load-ComboBox $combobox1 (Get-Process) "ProcessName"
#>
	Param (
		[ValidateNotNull()]
		[Parameter(Mandatory=$true)]
		[System.Windows.Forms.ComboBox]$ComboBox,
		[ValidateNotNull()]
		[Parameter(Mandatory=$true)]
		$Items,
	    [Parameter(Mandatory=$false)]
		[string]$DisplayMember,
		[switch]$Append
	)
	
	if(-not $Append)
	{
		$ComboBox.Items.Clear()	
	}
	
	if($Items -is [Object[]])
	{
		$ComboBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array])
	{
		$ComboBox.BeginUpdate()
		foreach($obj in $Items)
		{
			$ComboBox.Items.Add($obj)	
		}
		$ComboBox.EndUpdate()
	}
	else
	{
		$ComboBox.Items.Add($Items)	
	}

	$ComboBox.DisplayMember = $DisplayMember	
}
#endregion

$versionToolStripMenuItem_Click={
	[System.Windows.Forms.MessageBox]::Show("v0.0.1", "Version")
}

$helpToolStripMenuItem_Click={
	[System.Windows.Forms.MessageBox]::Show("Crypto Scanner will scan a specified machine for a file name or extension that you enter in. It will search all logical drives that contain the item you enter. The combobox uses the Active Directory module to automatically import computer objects. If the cmdlet is unavailable you can simply type a computer name to scan. You can specify the output as either a CSV or HTML report which will save on the running users desktop.", "About")
}


$prerequisitesToolStripMenuItem_Click={
	[System.Windows.Forms.MessageBox]::Show(
	"
COMBOBOX
-To load the combobox with domain computers you must be on the domain and have the proper permission to parse AD and get names of computer objects
-You must also have the Active Directory module installed

SCAN REMOTE COMPUTER
-To run a scan on another computer you must have PSRemoting enabled and you must have proper permissions on the target machine
", "Prerequisites")
	
}

$combobox_Server_SelectedIndexChanged = {
	
}

$radiobuttonHTML_CheckedChanged = {
	
}

$textbox_Extension_TextChanged = {
	
}

