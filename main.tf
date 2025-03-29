# **Terraform: GKE Cluster Setup (main.tf)**

provider "google" {
  project = "terraform-gcp-455203"  # Replace with your GCP project ID
  region  = "us-central1"
}

resource "google_container_cluster" "gke" {
  name     = "nginx-gke-cluster"
  location = "us-central1"
  enable_autopilot = true  # Free-tier eligible control plane
  deletion_protection = false
}