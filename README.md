# CryptoScanner-FileScanner


v0.0.1

####Description
CryptoScanner / FileScanner is a application written in PowerShell that can scan a local or remote computer for files hit by crypto. It searches based on user input by either entering in a extension or part of a file name. It will scan all logical disks attached to a machine (Disk Type 3). It will compile a report on all matching files, the size, directory they are located in, and the file owner. You can enter your own computer in the combobox or select one from the list. It uses the Active Directory PowerShell module to compile a list of computers so if you would like to use this feature you will need to install the AD module locally.

Included is the .exe if you just want to run it, or the .msi if you want to install it.

**Requires local admin rights to run

####Prerequisites

COMBOBOX
-To load the combobox with domain computers you must be on the domain and have the proper permission to parse AD and get names of computer objects
-You must also have the Active Directory module installed

SCAN REMOTE COMPUTER
-To run a scan on another computer you must have PSRemoting enabled on the target machine and you must have proper permissions on the target machine as well


####CryptoScanner GUI
![alt tag](https://github.com/bwya77/CryptoScanner-FileScanner/blob/master/Screenshots/Main_GUI.png)

####Login to O365
Here I am looking for extensions with .ecc on the local machine. I entered in localhost as the computer

![alt tag](https://github.com/bwya77/CryptoScanner-FileScanner/blob/master/Screenshots/LocalHost_Scan.png)

####Get-ADComputer to Fill the ComboBox
I have installed the Active Directory module locally so automatically the combobox is filled with computer objects found in AD
![alt tag](https://github.com/bwya77/CryptoScanner-FileScanner/blob/master/Screenshots/Parse_ComputerList.png)

####Result Files
You can get results in either a CSV format or HTML format
![alt tag](https://github.com/bwya77/CryptoScanner-FileScanner/blob/master/Screenshots/Results.png)
In the CSV I can view the files it found, the directory it is in, the size (Kb) and the file owner
![alt tag](https://github.com/bwya77/CryptoScanner-FileScanner/blob/master/Screenshots/Results_CSV.png)



