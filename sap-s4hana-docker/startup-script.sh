#!/bin/bash
apt update

# install dependencies for docker
apt install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin net-tools -y

# remove all packages that are not required any more after the upgarde
apt autoremove -y
apt upgrade -y

# pull the saptrial image from docker hub.
# this part will run for quite some time as the container is ~23GB compressed and >53GB uncompressed
docker pull sapse/abap-platform-trial:1909

# adjust the system limits for the container to start successfully
sysctl vm.max_map_count=2147483647
echo "vm.max_map_count=2147483647" >> /etc/sysctl.conf
sysctl fs.aio-max-nr=18446744073709551615
echo "fs.aio-max-nr=18446744073709551615" >> /etc/sysctl.conf

# start the docker Image once it is pulled. SAP wants you to use the interactive mode
# of docker to be able to trigger a clean shutdown of the system and allow the HANA
# database to write it's content to disk. Pleaes have a look at the docker container
# documentation at https://hub.docker.com/r/sapse/abap-platform-trial
docker run --sysctl kernel.shmmni=32768 --stop-timeout 3600 -i --name a4h -h vhcala4hci -p 3200:3200 -p 3300:3300 -p 8443:8443 -p 30213:30213 -p 50000:50000 -p 50001:50001 sapse/abap-platform-trial:1909 -agree-to-sap-license
