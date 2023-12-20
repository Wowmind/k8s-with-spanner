variable "project_id" {}

variable "credentials" {}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-b"
}

variable "spanner_config" {
  type = object({
    instance_name       = string
    database_name       = string
    configuration       = string
    display_name        = string
    processing_units    = number
    deletion_protection = bool
  })
  default = {
    instance_name = "spanner-k8s"
    database_name = "spanner-k8s-span"
    configuration = "regional-us-central1"
    display_name = "testing-k8s-spanner"
    processing_units = 100
    deletion_protection = false
  }
  description = "The configuration specifications for the Spanner instance"

  validation {
    condition     = length(var.spanner_config.display_name) >= 4 && length(var.spanner_config.display_name) <= "30"
    error_message = "Display name must be between 4-30 characters long."
  }

  validation {
    condition     = (var.spanner_config.processing_units <= 1000) && (var.spanner_config.processing_units%100) == 0
    error_message = "Processing units must be 1000 or less, and be a multiple of 100."
  }
}


variable "gcp_project_services" {
  type        = list(any)
  description = "GCP Service APIs (<api>.googleapis.com) to enable for this project"
  default     = [
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
    "spanner.googleapis.com"
  ]
}


variable "gke_config" {
  type = object({
    cluster_name = string
    location = string
  })
  default = {
    cluster_name = "k8s-spanner"
    location = "us-central1"
  }

  description = "The configuration specifications for a GKE Autopilot cluster"
}