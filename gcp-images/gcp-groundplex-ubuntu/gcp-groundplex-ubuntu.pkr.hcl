packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.1.1"

    }
  }
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "download_url" {
  type = string
}

variable "gcp_account_file" {
  type = string
}

source "googlecompute" "groundplex-ubuntu" {
  project_id          = var.project_id
  subnetwork          = "default"
  source_image_family = "ubuntu-os-cloud"
  source_image        = "ubuntu-2304-lunar-amd64-v20231030"
  image_name          = "snaplogic-groundplex-{{timestamp}}"
  image_description   = "SnapLogic Groundplex on Ubuntu 23.04"
  instance_name       = "snaplogic-groundplex-{{uuid}}"
  ssh_username        = "packer"
  tags                = ["packer"]
  zone                = var.zone
  account_file        = var.gcp_account_file
}

build {
  sources = [
    "source.googlecompute.groundplex-ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "DOWNLOAD_URL=${var.download_url}", 
    ]
    script = "./install-script.sh"
  }

}
