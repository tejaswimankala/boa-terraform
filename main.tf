terraform {
  required_version = "~>0.12"
}

#terraform {
 # required_providers {
    #kubernetes = {
      #source = "hashicorp/kubernetes"
      #version = "2.4.1"
    #}
 # }
#}


 
resource "google_container_cluster" "primary" {
  name               = var.cluster
  location           = var.zone
  initial_node_count = 2
  master_auth {
    username = ""
    password = ""
 
    client_certificate_config {
      issue_client_certificate = false
    }
  }
 
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
 
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
 timeouts {
    create = "30m"
    update = "40m"
  }
}
