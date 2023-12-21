//create spanner instance 

resource "google_spanner_instance" "instance" {
  name             = var.spanner_config.instance_name  # << be careful changing this in production
  config           = var.spanner_config.configuration
  display_name     = var.spanner_config.display_name
  processing_units = var.spanner_config.processing_units
  labels           = {
    "foo" = "bar"
  }

  depends_on = [google_project_service.service_api]
}

// create spanner database

resource "google_spanner_database" "database" {
  instance            = google_spanner_instance.instance.name
  name                = var.spanner_config.database_name
  deletion_protection = var.spanner_config.deletion_protection
 
}

// create gke autopilot

resource "google_container_cluster" "sample-game-gke" {
  name              = var.gke_config.cluster_name
  location          = var.gke_config.location
  network           = google_compute_network.vpc.name
  subnetwork        = google_compute_subnetwork.subnet.name

  # Use locked down service account
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.gke-sa.email
    }
  }

  # Enabling Autopilot for this cluster
  enable_autopilot  = true

  resource_labels = {
    "foo"         = "bar"
  }

  depends_on = [google_service_account.gke-sa]
}



data "google_container_cluster" "gke-provider" {
  name        = var.gke_config.cluster_name
  location    = var.gke_config.location

  depends_on  = [ google_container_cluster.sample-game-gke ]
}
