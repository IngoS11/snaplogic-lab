## Installation of SAP NW Developer edition via Terraform on GCP
The directory contains the instructions on installing SAP Netweaver Developer Edition using Terraform on Google Cloud Platform. The information derived is based on two blogs that can be found on the SAP Community Network as [Concise Guide to install SAP NetWeaver Developer Edition on Ubuntu VM](https://blogs.sap.com/2019/10/20/concise-guide-to-install-sap-netweaver-developer-edition-on-ubuntu-vm/) and [Adjusting installer script for SAP NetWeaver Dev Edition for distros with kernel version 5.4 or higher](https://blogs.sap.com/2021/06/07/adjusting-installer-script-for-sap-netweaver-dev-edition-for-distros-with-kernel-version-5.4-or-higher/).


Additional Articles to install SAP Gui for Java on Mac Silicon
https://blogs.sap.com/2021/09/27/how-to-install-sap-gui-for-java-and-eclipse-adt-on-m1-macbook/


### Generate a License for the System
Once the docker container is fully started it will output amongst other things the Hardware key of your system. Grab the key and go to the URL https://go.support.sap.com/minisap/#/minisap to generate a license key. On the page use "A4H - SAP NetWeaver AS ABAP 7.4 and above (Linux / SAP HANA)" as a system, enter your personal data in the for blow the system selection as well as the hardware key below the system selection, agree to the license agreement with the checkbox and then click the Generate button. The license will download to your Downloads folder as a text file with the name A4H_Multiple.txt. 


ToDo: Find Installation Guide
License From: 
Find the hardware key by using transaction /nSLICENSE
Cloud also be printed on the output of the docker container
docker cp <path_to_liense_file> a4h:/opt/sap/ASABAP_license
docker exec -it a4h /usr/local/bin/asabap_license_update 

### User in the S/4HANA server and in the HANA database
```
Client: 000
User: SAP*
password: Ldtf5432

Client: 001
User: DEVELOPER
password:  Ldtf5432

SAP DB?
User: SYSTEM
Password Ldtf5432

HANA HDB database
user: sAPA4H
Password: Ldtf5432
```

### Useful command working with the a4h docker container
Check if the system has enough memory when starting up use

```>docker exec -it a4h free -h```

Check if there is enough disk space avaiable for the docker containe use

```>docker exec -it a4h df -h /```

Check if the HANA database is running

```>docker exec -it a4h su - hdbadm -c "sapcontrol -nr 02 -function GetProcessList"```

Copy the license file to the docker container
```>docker cp <Path_to_license_file> a4h:/opt/sap/ASABAP_license```

Apply the license file to the S/4HANA Server inside the container
```
>docker exec -it a4h /usr/local/bin/asabap_license_update
```
Check that the system is listening on the ports that are exposed
```>netstat -tulpn```
List the processes running inside the container use
```>docker exec -it a4h ps -ef```


