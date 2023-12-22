output "region" {
  value = var.region
  description = "GCloud region"
}

output "project_id" {
  value = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.gke-helloapp.name
  description = "GKE Cluster name"
}

output "kubernetes_clusterr_host" {
  value = google_container_cluster.gke-helloapp.endpoint
  description = "GKE Cluster host"
