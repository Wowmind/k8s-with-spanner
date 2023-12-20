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
  ddl_statements = [
    "CREATE TABLE Players (PlayerUuid STRING(36) NOT NULL, FirstName STRING(1024), LastName STRING(1024), BirthDate DATE) PRIMARY KEY(PlayerUuid)"
  ]
  extra_statements = [
    "ALTER DATABASE hello-database SET OPTIONS (default_leader = 'us-central1-a')"
  ]
}
