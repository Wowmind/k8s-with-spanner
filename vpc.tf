resource "google_compute_network" "vpc" {
  name                    = "spanner-with-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.service_api]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-with-spanner"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
}