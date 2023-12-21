resource "google_service_account" "gke-sa" {
account_id    = "gke-cluster-account"
  display_name  = "Service account to manage GKE Autopilot cluster"
  project       = var.project_id
}

resource "google_project_iam_binding" "gke-identity-binding" {
  project       = var.project_id
  role          = "roles/container.nodeServiceAccount"

  members = [
     "serviceAccount:${google_service_account.gke-sa.email}",
  ]

  depends_on = [google_project_service.service_api, google_service_account.gke-sa]
}
