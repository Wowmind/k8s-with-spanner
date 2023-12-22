resource "google_service_account" "gke-helloapp" {
account_id    = "gke-cluster-account"
display_name  = "gke-helloapp"
project       = var.project_id
}

resource "google_project_iam_binding" "gke-identity-binding" {
  project       = var.project_id
  role          = "roles/container.nodeServiceAccount"

  members = [
     "serviceAccount:${google_service_account.gke-sa.email}",
  ]

  depends_on = [google_project_service.service_api, google_service_account.gke-helloapp]
}


resource "google_service_account" "my_service_account" {
  account_id   = "gsa-helloapp"
  display_name = "My Service Account"
}

resource "google_project_iam_binding" "my_iam_binding" {
  project = "var.project_id"
  role    = "roles/spanner.admin"
  members = [
    "serviceAccount:${google_service_account.my_service_account.email}"
  ]
}

resource "google_project_iam_binding" "my_iam_binding" {
  project = "spanner-gke"
  role    = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:spanner-gke.svc.id.goog[hello-namespace/gke-helloapp]"
  ]
}
