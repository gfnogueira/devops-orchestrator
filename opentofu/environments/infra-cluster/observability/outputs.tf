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

output "observability_namespace" {
  description = "Namespace where observability components are deployed"
  value       = module.observability.observability_namespace
}
