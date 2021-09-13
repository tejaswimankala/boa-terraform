provider "google" {
  # version     = "2.7.0"
  access_token = var.token
  project     = var.project
  region      = var.region
}

provider "kubernetes" {
  version = "~> 1.10.0"
}
