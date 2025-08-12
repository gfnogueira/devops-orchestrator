output "monitoring_namespace" {
  description = "The namespace where alerts were created"
  value       = var.monitoring_namespace
}

output "prometheus_rule_name" {
  description = "Name of the created PrometheusRule"
  value       = kubernetes_manifest.devops_alerts.manifest.metadata.name
}
