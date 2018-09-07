
# Windows Forensics Artifact Script
# This script will get forensic artifacts for a Windows based system
# Author : Priya Gopani

# Get Time
Write-Host "-------Time------"
$time = get-date -Format HH:mm:ss
$timezone= Get-TimeZone
$uptime=(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime

Write-Host "Time:"$time
Write-Host "Time Zone:" $timezone
Write-Host "Boot Time:" $uptime

Write-Host "------------------------------" 

# Get Operating Version
Write-Host "---------OS Version-----------"

$OS =(Get-WmiObject Win32_OperatingSystem).Name
$type =(Get-WmiObject Win32_OperatingSystem).OSArchitecture
$ram=(systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()

Write-Host "-------------------------------"
# Get System Hardware Specs
Write-Host "-----System Hardware Specs-----"

Write-Host "Operating System:" $OS
Write-Host "Brand & Type:" $type
Write-Host "RAM:" $ram

Write-Host "----------------------------"

# Get Domain Controller
Write-Host "---Domain Controller---"
echo "Domain COntroller"
Write-Host "---------------------------"

# Get Hostname $ Domain Info
Write-Host "---Hostname & Domain Information----"
Get-CimInstance Win32_ComputerSystem | select-object Name,PrimaryOwnerContact,UserName,Description,DNSHostName,Domain,workgroup,Manufacturer,Model,SystemFamily,SystemSKUNumber,SystemType,TotalPhysicalMemory
Write-Host "----------------------------"

# Get User Information
Write-Host "---------User Information-----------"
echo "Users: "
echo $user
Write-Host "---------------------------"

# Get start at boot info
Write-Host "---------Start at Boot---------------"
Write-Host "Items that start at Boot:"
Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-List
Write-Host " -------------------------------------"

# Get scheduled task info
Write-Host "-------------Scheduled Tasks-------------"

Get-ScheduledTask |Format-Table

Write-Host " -------------------------------------"



# Gets all the Network Information
Write-Host "---------Network Information---------"
$arp = arp -a
$mac= getmac
$routetable= netstat -r
$ipaddress= Get-NetIpAddress
$dhcp=Get-WmiObject Win32_NetworkAdapterConfiguration | select DHCPServer
$DNSserver=Get-DnsClientServerAddress | select-object -ExpandProperty Serveraddresses
$listserv= netstat -a -o -q -b
$estconn= Get-NetTCPConnection -State Established
$dnscache=Get-DnsClientCache
 


Write-Host "Arp Table"
$arp | Format-Table
Write-Host "Mac Addresses For All Interfaces"
$mac | Format-Table
Write-Host
Write-Host "Routing Table"
$routetable | Format-Table
Write-Host "Ip addresses for all Interfaces"
$ipaddress | Format-Table
Write-Host "DHCP Server Table"
$dhcp | Format-Table
Write-Host "DNS Server"
$DNSserver
Write-Host "Listening Services"
$listserv | Format-Table
Write-Host "Established Connections"
$estconn | Format-Table
Write-Host "DNS Cache"
$dnscache

Write-Host "------------------------------------------"

# Get printer info
Write-Host " -----Printers & Wifi Access Points-----"

Write-Host "Printers"
Get-Printer | Format-Table
Write-Host "Wifi Access Profiles"
Get-NetIPInterface | Format-Table
Write-Host "-------------------------------------------"

# Get installed software info
Write-Host "-------List of Installed Software----------"
Get-WmiObject -Class Win32_Product | Format-Table
Write-Host "-------------------------------------------"

# Get process info
Write-Host "-------Process Tables-----------------------"
Get-Process | Format-Table
Write-Host "-------------------------------------------"

# Get driver info
Write-Host "--------------Driver List------------------"
Get-WindowsDriver –Online -All | Format-Table
Write-Host "-------------------------------------------"

# Get download and doc info
Write-Host "------Downloads & Documents----------------"

foreach ($directory in Get-ChildItem -Path 'C:\Users') {
    if(Test-Path "C:\Users\$directory\Documents") {
        ls C:\Users\$directory\Documents
        }
    if(Test-Path "C:\Users\$directory\Downloads") {
        ls C:\Users\$directory\Downloads
    }
    }

Write-Host "--------Custom Adds -------------------------"

# Gets Firewall Rules

$firewall=Get-NetFirewallRule
echo "Firewall Rules"
echo $firewall

# Recent 20 events in Security Log

$seclog= get-eventlog security -newest 20
echo "Recent 20 Events in Security Log"
echo $seclog | Format-Table

# Get Background Tasks:
$backGrnds = Get-AppBackgroundTask
Get-AppBackgroundTask | Format-Table

Write-Host "---------------------------------------------"
