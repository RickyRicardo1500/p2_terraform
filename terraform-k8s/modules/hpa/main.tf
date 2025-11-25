resource "kubernetes_horizontal_pod_autoscaler_v2" "autoscaler" {
  metadata {
    name      = "${var.deployment}-hpa"
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.deployment
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}
