output "instance_id" {
  description = "Instance ID"
  value       = google_compute_instance.sap_a4h_dev.instance_id
}

output "sap_a4h_public_ip" {
  description = "Public IP address of SAP Instance"
  value = google_compute_address.sap_a4h_ip.address
}
