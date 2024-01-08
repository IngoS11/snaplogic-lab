#!/bin/bash -e
sudo apt update

# install packages that may be of help during debugging sessions
sudo apt install net-tools ca-certificates -y

# install dependencies for snaplogic groundplex
sudo apt install fontconfig zip -y

# download the groundplex installer from the URL that was provided when crating the groundplex
# in snapLogic
curl -o groundplex.deb $DOWNLOAD_URL

# install groundplex
sudo dpkg -i ./groundplex.deb 

# Add environment variable in /etc/sysconfig/jcc for the groundplex to find java
sudo mkdir -p /etc/sysconfig/
export JDKPATH=$(find /opt/snaplogic/pkgs -maxdepth 1 -type d -iname "jdk-*")
sudo -E bash -c 'echo "export SL_JAVA_HOME=$JDKPATH/" > /etc/sysconfig/jcc'

# make systemlimits larger for snapuser
sudo bash -c 'cat <<EOT >> /etc/security/limits.conf
snapuser soft nproc 8192
snapuser hard nproc 65536
snapuser soft nofile 8192
snapuser hard nofile 65536
EOT'

# Create a systemd service file and enable the service for the groundplex to restart after system reboot
sudo bash -c 'cat > /lib/systemd/system/snaplogic.service <<EOL
[Unit]
Description=SnapLogic JVM
After=network.target

[Service]
Type=forking
ExecStart=/opt/snaplogic/bin/jcc.sh start
ExecReload=/opt/snaplogic/bin/jcc.sh restart
ExecStop=/opt/snaplogic/bin/jcc.sh stop

[Install]
WantedBy=default.target
EOL'

sudo chmod 664 /lib/systemd/system/snaplogic.service

# Add /etc/services entries for the SAP gateway. These entries are required for
# the SAP RFC Listener Snap to find the port of the SAP Gateway. Please add or
# expand the list here when SAP system numbers other than 00 are needed
sudo bash -c 'echo "# SAP Gateway entries for the SAP RFC Listener Snap to find the SAP Gateway" >> /etc/services'
sudo bash -c 'echo "sapgw00         3300/tcp                        # SAP System Gateway Port" >> /etc/services'
sudo bash -c 'echo "sapgw00s        4800/tcp                        # SAP System Gateway Security Port" >> /etc/services'
