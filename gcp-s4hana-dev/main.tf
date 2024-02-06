data "google_compute_network" "sap_a4h_vpc" {
  name = "${var.project_name}-vpc"
}

data "google_compute_subnetwork" "sap_a4h_subnet" {
  name   = "${var.project_name}-${var.region}-subnet"
  region = var.region
}

resource "google_compute_firewall" "sap-a4h" {
  name    = "${var.project_name}-sap-a4h-world"
  network = data.google_compute_network.sap_a4h_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "3200", "3300", "4800", "8443", "30213", "50000", "50001"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sap-a4h"]
}

resource "google_compute_address" "sap_a4h_ip" {
  name = "${var.instance_name}-ip"
}

resource "random_pet" "sap_a4h_server" {
  keepers = {
    # Generate a new id each time we switch to a new image
    image_name = var.image_name
  }
}

resource "google_compute_instance" "sap_a4h_dev" {
  name         = "${var.instance_name}-${random_pet.sap_a4h_server.id}"
  hostname     = "${var.host_name}.${var.gcp_project}.internal"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["sap-a4h"]

  metadata_startup_script = file("./startup-script.sh")

  boot_disk {
    initialize_params {
      image = var.image_name
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.sap_a4h_subnet.self_link

    access_config {
      nat_ip = google_compute_address.sap_a4h_ip.address
    }
  }

}