provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.cluster_name}-subnet"
  region                   = var.region
  ip_cidr_range            = "10.10.0.0/16"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.20.0.0/16"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.30.0.0/20"
  }
}

resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.zone

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  networking_mode = "VPC_NATIVE"
}

resource "google_container_node_pool" "default_pool" {
  name       = "default-pool"
  location   = var.zone
  cluster    = google_container_cluster.gke.name
  node_count = 3

  node_config {
    machine_type = "e2-standard-2"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    labels       = { env = "lab" }
    tags         = ["gke", "lab"]
    disk_size_gb  = 50
 }
}

output "cluster_name" { value = google_container_cluster.gke.name }
output "endpoint"     { value = google_container_cluster.gke.endpoint }
