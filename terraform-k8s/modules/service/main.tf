resource "kubernetes_service" "svc" {
  metadata {
    name      = "nginx-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
