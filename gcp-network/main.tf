
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

