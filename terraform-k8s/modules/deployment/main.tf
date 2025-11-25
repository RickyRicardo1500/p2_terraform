resource "kubernetes_deployment" "app" {
  metadata {
    name      = "nginx-app"
    namespace = var.namespace
    labels = {
      app = "nginx-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "nginx-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-app"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = var.image

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

output "name" {
  value = kubernetes_deployment.app.metadata[0].name
}

output "app_label" {
  value = "nginx-app"
}
