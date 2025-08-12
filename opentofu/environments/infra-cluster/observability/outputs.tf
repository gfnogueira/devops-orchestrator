#output "prometheus_endpoint" {
#  description = "Prometheus service endpoint"
#  value       = module.observability.prometheus_endpoint
#  sensitive   = false
#}

output "grafana_service" {
  description = "Grafana service details" 
  value       = module.observability.grafana_service
  sensitive   = true
}

output "monitoring_namespace" {
  description = "Namespace where monitoring components are deployed"
  value       = module.observability.monitoring_namespace
}
