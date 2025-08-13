variable "observability_namespace" {
  description = "Namespace to install observability tools"
  type        = string
  default     = "observability"
}
variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "prometheus_enabled" {
  description = "Enable Prometheus deployment"
  type        = bool
  default     = true
}

variable "grafana_enabled" {
  description = "Enable Grafana deployment"
  type        = bool
  default     = true
}

variable "alertmanager_enabled" {
  description = "Enable AlertManager deployment"
  type        = bool
  default     = true
}

variable "prometheus_storage_size" {
  description = "Prometheus storage size"
  type        = string
  default     = "10Gi"
}

variable "grafana_storage_size" {
  description = "Grafana storage size"
  type        = string
  default     = "5Gi"
}

variable "prometheus_retention_days" {
  description = "Prometheus data retention in days"
  type        = number
  default     = 15
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "prom-operator"
  sensitive   = true
}

variable "service_monitors_only" {
  description = "Deploy only ServiceMonitors (for application cluster)"
  type        = bool
  default     = false
}

variable "enable_node_exporter" {
  description = "Enable Node Exporter (node metrics)"
  type        = bool
  default     = true
}

variable "enable_kube_state_metrics" {
  description = "Enable Kube State Metrics (Kubernetes resource metrics)"
  type        = bool
  default     = true
}
