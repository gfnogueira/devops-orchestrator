output "prometheus_rule_created" {
  description = "Confirms that PrometheusRule alerts were created successfully"
  value       = "PrometheusRule alerts deployed to namespace: ${module.observability_alerts.observability_namespace}"
}
