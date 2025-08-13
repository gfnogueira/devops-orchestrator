################################################################################
# OBSERVABILITY ALERTS MODULE - PrometheusRule only
################################################################################

################################################################################
# Alerts for Prometheus (using PrometheusRule)
################################################################################
resource "kubernetes_manifest" "devops_alerts" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"
    metadata = {
      name      = "devops-alerts"
      namespace = var.observability_namespace
      labels = {
        "prometheus" = "kube-prometheus"
        "role"       = "alert-rules"
      }
    }
    spec = yamldecode(file("${path.module}/alerts/devops-alerts.yaml"))
  }
}
