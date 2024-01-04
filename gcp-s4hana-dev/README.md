## Installation of SAP NW Developer edition via Terraform on GCP
The directory contains Terraform scripts that stand up a Ubuntu server running the SAP ABAP Trial Platform. The SAP system is delivered as a docker container that can be found at https://hub.docker.com/r/sapse/abap-platform-trial. Please read though that information for detailed instructions on the container. The terraform only creates the necessary resources on Google Cloud Platform, installs Docker and required tools and makes necessary system changes to run the container. By default the terraform requires the VPC that can be stood up by using the Terraform in [gcp-network] but can also be used in your own VPC.

### Generate a License for the System
Once the docker container is fully started it will output amongst other things the Hardware key of your system. Grab the key and go to the URL https://go.support.sap.com/minisap/#/minisap to generate a license key. On the page use "A4H - SAP NetWeaver AS ABAP 7.4 and above (Linux / SAP HANA)" as a system, enter your personal data in the for blow the system selection as well as the hardware key below the system selection, agree to the license agreement with the checkbox and then click the Generate button. The license will download to your Downloads folder as a text file with the name A4H_Multiple.txt. Copy the key to the system via scp, then ssh into the system and copy the License file into the container and then run the update license command.
```
docker cp <path_to_liense_file> a4h:/opt/sap/ASABAP_license
docker exec -it a4h /usr/local/bin/asabap_license_update 
```
For more information on installing the license refer to the [ABAP Platform Trial docker container page](https://hub.docker.com/r/sapse/abap-platform-trial)

### Useful commands working with the a4h docker container
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
