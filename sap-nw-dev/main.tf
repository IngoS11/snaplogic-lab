resource "google_compute_disk" "sap_nw_source_disk" {
  name = "sap-nw-dev-source-disk"
  type = "pd-standard"
  zone = var.zone
  snapshot = var.sap-nw-dev-disk-1-data-snp2
  size = "150"
}

resource "google_compute_instance" "sap_nw_dev" {
  name         = var.instance_name
  hostname     = "${var.host_name}.ingos-sandbox.internal"
  machine_type = var.machine_type
  zone         = var.zone

  metadata_startup_script = file("./startup-script.sh")

  boot_disk {
    initialize_params {
      image = var.image_name
      size = var.boot_disk_size
    }
  }

  network_interface {
    network = var.vpc_name

    access_config {

    }
  }

  attached_disk {
    source = google_compute_disk.sap_nw_source_disk.id
    device_name = google_compute_disk.sap_nw_source_disk.name
  }
  
}