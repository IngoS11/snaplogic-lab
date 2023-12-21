data "google_compute_network" "vpc" {
  name = "${var.project_name}-vpc"
}

data "google_compute_subnetwork" "subnet" {
  name   = "${var.project_name}-${var.region}-subnet"
  region = var.region
}

resource "google_compute_firewall" "snaplogic_ground_plex" {
  name    = "${var.project_name}-snaplogic-groundplex-world"
  network = data.google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["snaplogic-groundplex"]
}

resource "google_compute_address" "snaplogic_ground_plex_ip" {
  name = "${var.instance_name}-ip"
}

resource "random_pet" "snaplogic_groundplane" {
  keepers = {
    # Generate a new id each time we switch to a new image
    image_name = var.image_name
  }
}

resource "google_compute_instance" "snaplogic_ground_plex" {
  name         = "${var.instance_name}-${random_pet.snaplogic_groundplane.id}"
  hostname     = "${var.host_name}.${var.gcp_project}.internal"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["snaplogic-groundplex"]

  metadata_startup_script = templatefile("${path.module}/startup-script.tftpl",
    { download_url = var.groundplex_download_url,
  splz_url = var.groundplex_splz_url })

  boot_disk {
    initialize_params {
      image = random_pet.snaplogic_groundplane.keepers.image_name
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnet.self_link

    access_config {
      nat_ip = google_compute_address.snaplogic_ground_plex_ip.address
    }
  }

}