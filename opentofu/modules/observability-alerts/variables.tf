variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring resources"
  type        = string
  default     = "monitoring"
}
