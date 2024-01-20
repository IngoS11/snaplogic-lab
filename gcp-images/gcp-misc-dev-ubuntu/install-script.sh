#!/bin/bash -e
sudo apt update

# install dependencies for docker
sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo -E bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
sudo -E bash -c 'echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null'
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin net-tools -y

# install Samba so we can use it with the File Snap
sudo apt install samba postgresql-client-common -y

# make systemlimits larger for snapuser
sudo bash -c 'cat <<EOT >> /etc/samba/smb.conf
[sambashare]
    comment = Samba on Ubuntu
    path = /opt/smbshare
    read only = no
    browsable = yes
EOT'
sudo ufw allow samba
# add a share for Samba
sudo mkdir -p /opt/smbshare
sudo mv /home/packer/*.csv /opt/smbshare/

# disabe the Samba Active Directory service
sudo systemctl disable samba

# move the custom postgres pg_hba.conf file to /etc/postgresql
sudo mkdir -p /etc/postgresql
sudo mv /home/packer/pg_hba.conf /etc/postgresql/pg_hba.conf
sudo chown root:root /etc/postgresql/pg_hba.conf

# remove all packages that are not required any more after the upgarde
sudo apt autoremove -y
#sudo apt upgrade -y

# pull the saptrial image from docker hub.
# this part will run for quite some time as the container is ~23GB compressed and >53GB uncompressed
sudo docker pull $JMS_DOCKER_IMAGE
sudo docker pull $POSTGRES_DOCKER_IMAGE
sudo docker pull $ADMINER_DOCKER_IMAGE


