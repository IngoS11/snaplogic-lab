
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
    ports    = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  priority      = "65534"
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

  priority      = "65534"
  source_ranges = ["0.0.0.0/0"]
}

# create a could router for private instances to talk to the internet
resource "google_compute_router" "router" {
  name    = "${var.project_name}-router"
  network = google_compute_network.vpc.id
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# create a nat gateway that will have a public IP to allow private instances
# to talk to the internet
resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.project_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

locals {
    bastion_count = (var.create_bastion_server == true ? 1 : 0 )
}

resource "random_pet" "bastion_server" {
  keepers = {
    # Generate a new id each time we switch to a new image
    image_name = var.bastion_image_name
  }
}

resource "google_compute_instance" "bastion_server" {
  count        = local.bastion_count
  name         = "${var.instance_name}-${random_pet.bastion_server.id}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["bastion"]

  boot_disk {
    initialize_params {
      image = random_pet.bastion_server.keepers.image_name
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link

    access_config {
    }
  }

}