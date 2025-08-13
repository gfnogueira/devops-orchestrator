output "observability_namespace" {
  description = "Namespace used for observability tools"
  value       = var.observability_namespace
}

output "prometheus_release" {
  description = "Prometheus Helm release information"
  value = var.prometheus_enabled ? {
    name      = helm_release.prometheus_stack.name
    namespace = helm_release.prometheus_stack.namespace
    version   = helm_release.prometheus_stack.version
    status    = helm_release.prometheus_stack.status
  } : null
}

output "prometheus_service" {
  description = "Prometheus service details"
  value = var.prometheus_enabled ? {
    name = "${helm_release.prometheus_stack.name}-kube-prom-prometheus"
    port = 9090
  } : null
}

output "grafana_service" {
  description = "Grafana service details"
  value = var.grafana_enabled ? {
    name = "${helm_release.prometheus_stack.name}-grafana"
    port = 80
    admin_password = var.grafana_admin_password
  } : null
  sensitive = true
}

output "alertmanager_service" {
  description = "AlertManager service details"
  value = var.alertmanager_enabled ? {
    name = "${helm_release.prometheus_stack.name}-kube-prom-alertmanager"
    port = 9093
  } : null
}

