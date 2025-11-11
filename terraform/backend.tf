terraform {
  backend "gcs" {
    bucket = "tf-state-gke-lab-project-477915"
    prefix = "gke-workload"
  }
}
