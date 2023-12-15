terraform {
  backend "gcs" {
    bucket = "ingos-sandbox-terraform-state"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60"
    }
  }
}

provider "google" {
  project     = "ingos-sandbox"
  region      = "us-west1"
  credentials = "../gcp-terraform-key.json"
}

