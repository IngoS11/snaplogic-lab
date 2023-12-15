variable "instance_name" {
  description = "Instance name on GCP"
  type        = string
  default     = "sap-nw-dev"
}

variable "host_name" {
  description = "Name of the Instance for the SAP NW Dev System. Do not change default name due to RFC issues."
  type        = string
  default     = "vhcalnplci"
}

variable "machine_type" {
  description = "Instance Type to use for the SAP NW Dev System"
  type        = string
  default     = "e2-standard-2"
}

variable "boot_disk_size" {
  description = "Size of the boot disk to fit the SAP NW Dev System on the same disk as the operating system"
  type = string
  default = "150"
}

variable "zone" {
  description = "Default Zone for the Instanace"
  type        = string
  default     = "us-west1-c"
}

variable "region" {
  description = "Default Region for the Instanace"
  type        = string
  default     = "us-west1"
}

variable "image_name" {
  description = "Image Name of the Operating System to use"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2304-lunar-amd64-v20231030"
}

variable "vpc_name" {
  description = "Virtual Private Network to put the instance in"
  type        = string
  default     = "default"
}

variable "sap-nw-dev-disk-1-data-snp2" {
  description = "Name of the snapshot containing the source files for the SAP NW Developer installation"
  type        = string
  default     = "sap-nw-dev-disk-1-data-snp2"  
}