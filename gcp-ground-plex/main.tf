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

locals {
  acz = slice(data.google_compute_zones.available.names, 0, var.groundplex_count)
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

# enable the secretmanager api in case it is not yet enabled in the project
# this only needs to be done one pre project but is an indempotent operation
resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"
}

resource "google_secret_manager_secret" "snaplogic_ground_plex_slpropz" {
  secret_id = "snaplogic_groundplex_slpropz"

  labels = {
    label = "snaplogic"
  }

  replication {
    auto {}
  }

  depends_on = [google_project_service.secretmanager]

}

resource "google_secret_manager_secret_version" "groundplex_slpropz" {
  secret                = google_secret_manager_secret.snaplogic_ground_plex_slpropz.id
  secret_data           = filebase64(var.groundplex_slpropz)
  is_secret_data_base64 = true
}

# create a service account that will be used to run the compute engine instance
resource "google_service_account" "snaplogic_ground_plex" {
  account_id   = var.instance_name
  display_name = "Service account for ${var.instance_name} instnaces"
}

# grant the service account permission to read the secret that contains
# the Groundplex configuration
resource "google_secret_manager_secret_iam_member" "snaplogic_ground_plex" {

  secret_id = google_secret_manager_secret.snaplogic_ground_plex_slpropz.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.snaplogic_ground_plex.email}"

  depends_on = [google_service_account.snaplogic_ground_plex]
}

# allow the new service account to be used on the groundplex instances
resource "google_service_account_iam_member" "snaplogic_ground_plex" {
  service_account_id = google_service_account.snaplogic_ground_plex.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.snaplogic_ground_plex.email}"

  depends_on = [google_service_account.snaplogic_ground_plex]
}

resource "random_pet" "snaplogic_ground_plex" {
  count = length(local.acz)
  keepers = {
    # Generate a new id each time we switch to a new image
    image_name = var.groundplex_image_name
  }
}

# create a single instance of the groundplex
resource "google_compute_instance" "snaplogic_ground_plex" {
  count        = length(local.acz)
  name         = "${var.instance_name}-${random_pet.snaplogic_ground_plex[count.index].id}"
  machine_type = var.machine_type
  zone         = local.acz[count.index]
  tags         = ["snaplogic-groundplex"]

  metadata_startup_script = templatefile("${path.module}/startup-script.tftpl",
    { gcp_slpropz_secret = google_secret_manager_secret.snaplogic_ground_plex_slpropz.secret_id
  })

  boot_disk {
    initialize_params {
      image = random_pet.snaplogic_ground_plex[count.index].keepers.image_name
      size  = var.boot_disk_size
    }
  }

  service_account {
    email  = google_service_account.snaplogic_ground_plex.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnet.self_link
  }

  depends_on = [google_service_account.snaplogic_ground_plex]

}