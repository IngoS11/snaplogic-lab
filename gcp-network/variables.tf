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
