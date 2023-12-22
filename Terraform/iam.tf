resource "google_service_account" "gke-helloapp" {
account_id    = "gke-cluster-account"
display_name  = "gke-helloapp"
project       = var.project_id
}

resource "google_project_iam_binding" "gke-identity-binding" {
  project       = var.project_id
  role          = [
   "roles/container.nodeServiceAccount", "roles/iam.workloadIdentityUser"
  ]

  members = [
     "serviceAccount:${google_service_account.gke-helloapp.email}",
  ]

  depends_on = [google_service_account.gke-helloapp]

}


resource "google_service_account" "my_service_account" {
  account_id   = "gsa-helloapp"
  display_name = "My Service Account"
}

resource "google_project_iam_binding" "my_iam_binding" {
  project = var.project_id
  role    = "roles/spanner.admin"
  members = [
    "serviceAccount:${google_service_account.my_service_account.email}"
  ]
}
