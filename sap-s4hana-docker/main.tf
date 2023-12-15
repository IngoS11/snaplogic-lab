
resource "google_compute_network" "sap_a4h_vpc" {
  name                            = "sap-a4h-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "sap_a4h_us_west1" {
  name                     = "sap-a4h-${var.region}-subnet"
  ip_cidr_range            = "192.168.1.0/24"
  region                   = var.region
  network                  = google_compute_network.sap_a4h_vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "sap-a4h" {
  name    = "sap-a4h-firewal-any"
  network = google_compute_network.sap_a4h_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "3200", "3300", "8443", "30213", "50000", "50001"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sap-a4h"]
}

resource "google_compute_address" "sap_a4h_ip" {
  name = "sap-a4h-ip"
}

resource "google_compute_instance" "sap_a4h_dev" {
  name         = var.instance_name
  hostname     = "${var.host_name}.ingos-sandbox.internal"
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
    subnetwork = google_compute_subnetwork.sap_a4h_us_west1.self_link

    access_config {
      nat_ip = google_compute_address.sap_a4h_ip.address
    }
  }

}