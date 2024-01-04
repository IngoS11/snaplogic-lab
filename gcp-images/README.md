Follow the guides on creating a service user for packager as well as authentication to GCP to create a user that is able to build the image under
https://developer.hashicorp.com/packer/integrations/hashicorp/googlecompute#authentication

## Configuring Service Account for Packer
Below steps create an example Packer service account using `gcloud` to run Packer acting as a given service account.

1. Set GCP project variables. Substitute `my-project` with your project identifier.

   ```sh
   export PROJECT_ID=<my-project>
   export PROJECT_NUMBER=`gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)"`
   ```

2. Create Service Account for Packer

   ```sh
   gcloud iam service-accounts create packer --description "Packer image builder"
   ```

3. Grant roles to Packer's Service Account

   ```sh
   gcloud projects add-iam-policy-binding $PROJECT_ID \
     --role="roles/compute.instanceAdmin.v1" \
     --member="serviceAccount:packer@${PROJECT_ID}.iam.gserviceaccount.com"
   gcloud projects add-iam-policy-binding $PROJECT_ID \
     --role="roles/iam.serviceAccountUser" \
     --member="serviceAccount:packer@${PROJECT_ID}.iam.gserviceaccount.com"
   ```
4. Create a Key for the Service Account, download the key and put it into the root folder of the repostory. Adjust the `./variables.auto.pkrvars.hcl` file
   in the directory of the images you want to buid to point the `gcp_account_file` variable to point to the file.

## Executing the Packer Builder

1. Adjust packer variables

   Make a copy of the provided packer.pkvars.template file found in the root directoy of the repository to packer.pkrvars.
   Adjust the variables in the new file to match your configuration on GCP
   
2. Run the build
  
   change to the directly containing the scripts to buid the image you are intending to build and run 
   ```
   packer build .
   ```
