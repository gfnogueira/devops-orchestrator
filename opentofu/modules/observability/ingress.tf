################################################################################
# INGRESS FOR GRAFANA
################################################################################

resource "kubernetes_ingress_v1" "grafana_ingress" {
  depends_on = [helm_release.prometheus_stack]

  metadata {
    name      = "grafana-ingress"
    namespace = var.observability_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "grafana.127.0.0.1.nip.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

################################################################################
# INGRESS FOR PROMETHEUS
################################################################################

resource "kubernetes_ingress_v1" "prometheus_ingress" {
  depends_on = [helm_release.prometheus_stack]

  metadata {
    name      = "prometheus-ingress"
    namespace = var.observability_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "prometheus.127.0.0.1.nip.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-operated"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}