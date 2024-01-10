//create spanner instance 

resource "google_spanner_instance" "instance" {
  name             = var.spanner_config.instance_name  # << be careful changing this in production
  config           = var.spanner_config.configuration
  display_name     = var.spanner_config.display_name
  processing_units = var.spanner_config.processing_units
  labels           = {
    "foo" = "bar"
  }

  depends_on = [google_service_account.my_service_account]
}

// create spanner database

resource "google_spanner_database" "hello-database" {
  instance            = google_spanner_instance.instance.name
  name                = var.spanner_config.database_name
  ddl      = [
    "CREATE TABLE Players (PlayerUuid STRING(36) NOT NULL, FirstName STRING(1024), LastName STRING(1024), BirthDate DATE) PRIMARY KEY(PlayerUuid)"
  ]
  deletion_protection = var.spanner_config.deletion_protection
 
}

// create gke autopilot

resource "google_container_cluster" "cluster-hellooapp" {
  name              = var.gke_config.cluster_name
  location          = var.gke_config.location
  network           = google_compute_network.spanner-network.name
  subnetwork        = google_compute_subnetwork.subnet.name

  # Enabling Autopilot for this cluster
  enable_autopilot  = true
  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.2.0.0/21"
  }

  resource_labels = {
    "foo"         = "bar"
  }

  depends_on = [google_service_account.gke-helloapp]
}

data "google_container_cluster" "gke-provider" {
  name        = var.gke_config.cluster_name
  location    = var.gke_config.location

  depends_on  = [ google_container_cluster.cluster-hellooapp]
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = "${data.google_client_config.current.access_token}"
  cluster_ca_certificate = "${base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)}"
}
