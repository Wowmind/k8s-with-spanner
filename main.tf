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

resource "google_spanner_database" "database" {
  instance            = google_spanner_instance.instance.name
  name                = var.spanner_config.database_name
  deletion_protection = var.spanner_config.deletion_protection
}
