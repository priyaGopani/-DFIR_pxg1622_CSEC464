#!/bin/bash
# This script will get forensics artifacts for a linux based system
# Author: Priya Gopani


function getTime(){
	echo "###### System Time ################################################################################################################"
	tim=$(date +"%T")
	zone=$(date +'%Z')
	uptim=$(uptime '-p')

	echo "Current Time: $tim"
	echo "Time Zone : $zone"
	echo "Uptime: $uptim"
	echo
}

function getOSVersion(){
	echo "###### Operating System #########################################################################################################"
    OS_name=$OSTYPE
	kernal=$(uname '-r') 
  
    echo "Operating System: $OS_name"
    echo "Kernal Version: $kernal"
    echo
}

function getHardware(){
	echo "###### System Hardware #########################################################################################################"
    CPU=`uname -p`
    RAM=`grep MemTotal /proc/meminfo | awk '{print $2}'`
	Hardrives=$(lsblk '-d')
	MountSys=$(df '-hT')

    echo "CPU:$CPU"
	echo
    echo "RAM:$RAM"
	echo
    echo "Hardrives:"
	echo "$Hardrives"
	echo
	echo "List of Mounted Systems:" 
	echo "$MountSys"
	echo

}

function getHostDomain(){
	echo "###### Host & Domain ##########################################################################################################"

	Host=`hostname`
	Domain=`domainname`

	echo "Hostname:$Host"
	echo "Domain name:$Domain"
	echo
}

function getUsers(){
	echo "###### System Hardware #######################################################################################################"

	localusers=`users`
	sysusers=$(cut -d: -f1 /etc/passwd)

	echo "Local Users:"
	echo "$localusers"
	echo
	echo "System Users:"
	echo "$sysusers"
	echo
}

function getstartatboot(){
  	echo "###### Start at Boot ########################################################################################################"

	services=`systemctl list-unit-files --type=service | grep -i enable`

	echo "Services Running at Boot:"
	echo
	echo "$services"
	echo
}


function getscheduledtasks(){
	echo "###### Scheduled Tasks ######################################################################################################"
	
	listtasks=$(crontab -l)

	echo "List of Scheduled Tasks: $listtasks"
	echo
} 

function getnetwork(){
	echo "######## System Network #####################################################################################################"

	arptable=`arp`
	mac=`cat /sys/class/net/*/address`
	rtable=`route`
	ipaddr=`ifconfig | awk '/inet addr/{print substr($2,6)}'`
	dhcp=`dhclient -d -nw eth0`
	dns=`cat /etc/resolv.conf | grep nameserver`
	gateway=`ip route`
	listenservices=`netstat -ln`
	estconn=`ss`
	

	echo "Arp Table"
	echo "$arptable"
	echo
	echo "Mac Addresses:"	
	echo "$mac"
	echo
	echo "Routing Table:"
	echo "$rtable"
	echo
	echo " IP Addresses:"
	echo $ipaddr
	echo
	echo "DHCP: "
	echo $dhcp
	echo
	echo "DNS Servers:"
	echo $dns
	echo
	echo "Gateway:"
	echo $gateway
	echo
	echo "Listening Services:"
	echo "$listenservices"
	echo
	echo "Established Connections:"
	echo "$estconn"
	echo

}


function getprinter(){
	echo "###### Start at Boot ####################################################################################################"

	echo
	echo "Printer Destinations:"
	printer=`lpstat -t`

	echo "$printer"
	echo
}

function getprocesses(){
	echo "###### Process List ####################################################################################################"
	echo
	
	proctable=`ps -axj`
	
	echo "$proctable"
	echo

	
}

function getdrivers(){
	echo "###### Driver List ####################################################################################################"
	echo
	
	proclist=`lsmod | cut -d ' ' -f1 | lsmod`
	
	echo "Process List:"
	echo
	echo "$proclist"
	echo

}
function getfiles(){
	echo "###### Downloads & Documents & Desktop ###################################################################################"
	docs=`ls /home/*/Documents`
	loads=`ls /home/*/Downloads`

	echo "All Documents:"
	echo "$docs"
	echo
	echo "All Downloads:"
	echo "$loads"
	echo
}

# 3 Personal Tools
function getcustom(){

	# custom tool 1: All Files in Desktop
	dskfiles=`ls ~/Desktop`
	echo "All Files in Desktop: "
	echo "$dskfiles"
	echo

	# custom tool 2: Find all images,type, and location with in System
	echo "################## All Images #############################################################################################"
	img=`find . -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image'`
	echo "All Images in System: " 
	echo "$img"
	echo

	# custom tool 3: Find Current KBytes free space on disk
	echo "################## Disk Space #############################################################################################"
	pat=`cd /var/log` 	
	dskspace=`$pat df -k . | awk '{print $4}'`
	
	echo "Free KBytes of Disk Space $dskspace"
	echo
}


function main(){
	getTime
	getOSVersion
	getHardware
	getHostDomain
	getUsers  
	getstartatboot
	getscheduledtasks
	getnetwork
	getprinter
	getprocesses
	getdrivers
	getfiles
	getcustom
}

main