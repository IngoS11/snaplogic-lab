variable "gcp_project" {}

variable "gcp_credentials_file" {}

variable "zone" {
  description = "Default Zone for the Instanace"
  type        = string
}

variable "region" {
  description = "Default Region for the Instanace"
  type        = string
}

variable "project_name" {
  description = "Project Name used throughout the objects created"
  type        = string
}

variable "cidr_range" {
  description = "CIDR Range for the Subnetwork that is used for all systems"
  type        = string
}

variable "vpc_cidr_range" {
  description = "CIDR Range for the entire VPC"

}

variable "instance_name" {
  description = "Bastion Host Instance Name"
  type = string
  default = "bastion"
}

variable "machine_type" {
  description = "Instance Type to use for the bastion server"
  type        = string
  default     = "e2-micro"
}

variable "bastion_image_name" {
  description = "Image Name of the Operating System to use"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2304-lunar-amd64-v20231030"
}

variable "create_bastion_server" {
  description = "True if a basion host should be stood up?"
  type = bool
  default = false
}
