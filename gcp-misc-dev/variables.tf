variable "gcp_project" {}

variable "gcp_credentials_file" {}

# not used here but needed to suppress warning due to existing entries in terraform.tfvars
variable "cidr_range" {}

variable "instance_name" {
  description = "Instance name on GCP"
  type        = string
  default     = "snaplogic-misc-servers"
}

variable "machine_type" {
  description = "Instance Type to use for the Server"
  type        = string
  default     = "e2-standard-2"
}

variable "boot_disk_size" {
  description = "Size of the boot disk"
  type        = string
  default     = "20"
}

variable "zone" {
  description = "Default Zone for the Instanace"
  type        = string
}

variable "region" {
  description = "Default Region for the Instanace"
  type        = string
}

variable "misc_servers_image_name" {
  description = "Image Name of the Image to use"
  type        = string
}

variable "project_name" {
  description = "Project Name used throughout the objects created"
  type        = string
}

variable "postgres_user" {
  description = "User for the postgres db"
  type        = string
  default     = "admin"
}

variable "postgres_pass" {
  description = "Password for the postgres user"
  type        = string
  default     = "abcd1234"
}

variable "activemq_user" {
    description = "User for ActiveMQ"
  type        = string
  default     = "admin"
}

variable "activemq_pass" {
  description = "Password for ActiveMQ"
  type        = string
  default     = "abcd1234"
}

variable "smb_user" {
  description = "User for Samba"
  type        = string
  default     = "admin"
}

variable "smb_pass" {
  description = "User for Samba"
  type        = string
  default     = "abcd1234"
}