terraform {
  backend "gcs" {
    bucket = "ingos-sandbox-terraform-state"
    prefix = "terraform/state-groundplex"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.region
  credentials = var.gcp_credentials_file
}
