#!/bin/bash
apt update
apt upgrade -y

# install rar and unrar. needed to unpack SAP NW Developer edition once
# downloaded from SAP
apt install unrar rar -y

#firewall, should be inactive; if active, deactivate it:
ufw disable

#the C-shell, for install and for npladm user
apt install csh -y
# install tcsh as it is easier for npladm (Admin of the system)
apt install tcsh -y
# install libaio1 
apt install libaio1 -y
#this is needed for generating unique id numbers.
apt install uuid -y

# make sure the uuid deamon is started
systemctl enable uuidd
systemctl start uuidd

# mount the sap nw developer trial source code disk
mkdir -p /mnt/disks/sapsource
mount /dev/sdb /mnt/disks/sapsource
