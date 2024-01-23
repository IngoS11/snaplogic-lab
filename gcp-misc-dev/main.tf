data "google_compute_network" "vpc" {
  name = "${var.project_name}-vpc"
}

data "google_compute_zones" "available" {
  region = var.region
}

data "google_compute_subnetwork" "subnet" {
  name   = "${var.project_name}-${var.region}-subnet"
  region = var.region
}

resource "google_compute_firewall" "snaplogic_misc_servers" {
  name    = "${var.project_name}-snaplogic-misc-servers-world"
  network = data.google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "8161", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["snaplogic-misc-servers"]
}

resource "google_compute_address" "snaplogic_misc_servers_ip" {
  name = "${var.instance_name}-ip"
}

resource "random_pet" "snaplogic_misc_servers" {
  keepers = {
    # Generate a new id each time we switch to a new image
    image_name = var.misc_servers_image_name
  }
}

# create a single instance of the groundplex
resource "google_compute_instance" "snaplogic_misc_servers" {
  name         = "${var.instance_name}-${random_pet.snaplogic_misc_servers.id}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["snaplogic-misc-servers"]

  metadata_startup_script = templatefile("${path.module}/startup-script.tftpl",
    { postgres_user = var.postgres_user,
      postgres_pass = var.postgres_pass,
      activemq_user = var.activemq_user,
      activemq_pass = var.activemq_pass,
      smb_user = var.smb_user,
      smb_pass = var.smb_pass,
  })

  boot_disk {
    initialize_params {
      image = random_pet.snaplogic_misc_servers.keepers.image_name
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnet.self_link

    access_config {
      nat_ip = google_compute_address.snaplogic_misc_servers_ip.address
    }
  }
}

resource "google_storage_bucket" "snaplogic_file_storage" {
  name          = "${var.project_name}-snaplogic-no-public-access"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}

# upload multiple CSV files containging sales agents
resource "google_storage_bucket_object" "agent_data_1" {
  name   = "agents/agent-data-1.csv"
  source = "data/Agent_1.csv"
  bucket = google_storage_bucket.snaplogic_file_storage.name
}

resource "google_storage_bucket_object" "agent_data_2" {
  name   = "agents/agent-data-2.csv"
  source = "data/Agent_2.csv"
  bucket = google_storage_bucket.snaplogic_file_storage.name
}

resource "google_storage_bucket_object" "agent_data_3" {
  name   = "agents/agent-data-3.csv"
  source = "data/Agent_3.csv"
  bucket = google_storage_bucket.snaplogic_file_storage.name
}

resource "google_storage_bucket_object" "agent_data_4" {
  name   = "agents/agent-data-4.csv"
  source = "data/Agent_4.csv"
  bucket = google_storage_bucket.snaplogic_file_storage.name
}
