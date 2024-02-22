variable "gcp_project" {}

variable "gcp_credentials_file" {}

# not used here but needed to suppress warning due to existing entries in terraform.tfvars
variable "cidr_range" {}

variable "instance_name" {
  description = "Instance name on GCP"
  type        = string
  default     = "snaplogic-groundplex"
}

variable "machine_type" {
  description = "Instance Type to use for the GroundPlex"
  type        = string
  default     = "e2-standard-2"
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

variable "groundplex_image_name" {
  description = "Image Name of the Operating System to use"
  type        = string
}

variable "project_name" {
  description = "Project Name used throughout the objects created"
  type        = string
}

variable "groundplex_slpropz" {
  description = "Groundplex configuration file downloaded from SnapLogic to a local file"
  type        = string
}

variable "groundplex_count" {
  description = "Number of Groundplexes to stand up. Max Number is based on avaiablity zones in region."
  type = number
  default = 1
}