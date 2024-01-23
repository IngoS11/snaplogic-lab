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

variable "gcp_account_file" {
  type = string
}

variable "jms_docker_image" {
  type = string
}

variable "postgres_docker_image" {
  type = string
}

variable "adminer_docker_image" {
  type = string
}

variable "smb_username" {
  type = string
}

variable "smb_password" {
  type = string
}

source "googlecompute" "groundplex-ubuntu" {
  project_id          = var.project_id
  subnetwork          = "default"
  source_image_family = "ubuntu-os-cloud"
  source_image        = "ubuntu-2304-lunar-amd64-v20240109"
  image_name          = "snaplogic-misc-dev-{{timestamp}}"
  image_description   = "Snaplogic Demo System with DB JMS SMB on Ubuntu 23.04"
  instance_name       = "snaplogic-misc-dev-{{uuid}}"
  ssh_username        = "packer"
  tags                = ["packer"]
  zone                = var.zone
  credentials_file    = var.gcp_account_file
}

build {
  sources = [
    "source.googlecompute.groundplex-ubuntu"
  ]

  provisioner "file" {
    source = "data/1000people.csv"
    destination = "/home/packer/1000people.csv"
  }

  provisioner "file" {
    source = "pg_hba.conf"
    destination = "/home/packer/pg_hba.conf"
  }

  provisioner "file" {
    source = "data/books.xml"
    destination = "/home/packer/books.xml"
  }

  provisioner "shell" {
    environment_vars = [
      "JMS_DOCKER_IMAGE=${var.jms_docker_image}",
      "POSTGRES_DOCKER_IMAGE=${var.postgres_docker_image}",
      "ADMINER_DOCKER_IMAGE=${var.adminer_docker_image}",
      "SMB_USER=${var.smb_username}",
      "SMB_PASS=${var.smb_password}",  
    ]
    script = "./install-script.sh"
  }

}
