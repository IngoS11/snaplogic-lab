
# Create a VCP that hosts all machines to demo SnapLogic GroundPlex
resource "google_compute_network" "vpc" {
  name                            = "${var.project_name}-vpc" 
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

# Create one Subnet that will host all the demo Systems. The subnet
# will always get the name of the vpc followed by the region and "-subnet"
resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.project_name}-${var.region}-subnet"
  ip_cidr_range            = var.cidr_range
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

# Create a firewall rule that allows instances instide the VPC to communicate
# with each other on any port using UDP
resource "google_compute_firewall" "all_in_vpc" {
  name    = "${var.project_name}-allow-all-internal"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }

  priority = "65534"
  source_ranges = [var.vpc_cidr_range]
}

# Create a firewall rule that allows instances inside the VPC to cummunicate
# with each other on any port using ICMP
resource "google_compute_firewall" "all_icmp_world" {
  name    = "${var.project_name}-allow-all-icmp-world"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "icmp"
  }

  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
}