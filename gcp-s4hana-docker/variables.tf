variable "gcp_project" {}

variable "gcp_credentials_file" {}

# not used here but needed to suppress warning due to existing entries in terraform.tfvars
variable "cidr_range" {}

variable "instance_name" {
  description = "Instance name on GCP"
  type        = string
  default     = "sap-s4hana-dev"
}

variable "host_name" {
  description = "Name of the Instance for the SAP NW Dev System. Do not change default name due to RFC issues."
  type        = string
  default     = "vhcalnplci"
}

variable "machine_type" {
  description = "Instance Type to use for the SAP S/4HANA System"
  type        = string
  default     = "e2-standard-8"
}

variable "boot_disk_size" {
  description = "Size of the boot disk to fit the SAP NW Dev System on the same disk as the operating system"
  type        = string
  default     = "190"
}

variable "zone" {
  description = "Default Zone for the Instanace"
  type        = string
}

variable "region" {
  description = "Default Region for the Instanace"
  type        = string
}

variable "image_name" {
  description = "Image Name of the Operating System to use"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2304-lunar-amd64-v20231030"
}

variable "project_name" {
  description = "Project Name used throughout the objects created"
  type        = string
}




