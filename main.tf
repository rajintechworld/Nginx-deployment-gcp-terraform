# ✅ Provider Configuration
provider "google" {
  project = "terraform-gcp-455203"  # Replace with your GCP project ID
  region  = "us-central1"
}

# ✅ Create a new VPC
resource "google_compute_network" "vpc_network" {
  name                    = "gke-custom-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# ✅ Create a subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.0.0/16"
}

# ✅ Firewall rule to allow internal and external traffic
resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# ✅ GKE Cluster using the new VPC and Subnet
resource "google_container_cluster" "gke" {
  name     = "nginx-gke-cluster"
  location = "us-central1"
  
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  enable_autopilot      = true
  deletion_protection   = false
}
