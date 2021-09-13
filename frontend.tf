resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        volume {
          name = "publickey"

          secret {
            secret_name = "jwt-key"

            items {
              key  = "jwtRS256.key.pub"
              path = "publickey"
            }
          }
        }

        container {
          name  = "front"
          image = "gcr.io/bank-of-anthos/frontend:v0.5.0"

          env_from {
            config_map_ref {
              name = "environment-config"
            }
          }

          env_from {
            config_map_ref {
              name = "service-api-config"
            }
          }

          env {
            name  = "VERSION"
            value = "v0.5.0"
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name  = "ENABLE_TRACING"
            value = "true"
          }

          env {
            name  = "SCHEME"
            value = "http"
          }

          env {
            name  = "LOG_LEVEL"
            value = "info"
          }

          env {
            name = "DEFAULT_USERNAME"

            value_from {
              config_map_key_ref {
                name = "demo-data-config"
                key  = "DEMO_LOGIN_USERNAME"
              }
            }
          }

          env {
            name = "DEFAULT_PASSWORD"

            value_from {
              config_map_key_ref {
                name = "demo-data-config"
                key  = "DEMO_LOGIN_PASSWORD"
              }
            }
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "256Mi"
            }

            requests {
              cpu    = "100m"
              memory = "64Mi"
            }
          }

          volume_mount {
            name       = "publickey"
            read_only  = true
            mount_path = "/root/.ssh"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "8080"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 30
            period_seconds        = 15
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "8080"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 10
            period_seconds        = 5
          }
        }

        termination_grace_period_seconds = 5
        service_account_name             = "default"
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "frontend"
    }

    type = "LoadBalancer"
  }
}
