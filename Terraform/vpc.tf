resource "google_compute_network" "spanner-network" {
  name                    = "spanner-with-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-with-spanner"
  ip_cidr_range = "10.1.0.0/21"
  region        = "us-central1"
  network       = google_compute_network.spanner-network.name
}
