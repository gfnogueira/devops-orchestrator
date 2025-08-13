variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins deployment"
  type        = string
  default     = "jenkins"
}

variable "jenkins_image" {
  description = "Jenkins Docker image"
  type        = string
  default     = "jenkins/jenkins:lts"
}

variable "github_username" {
  description = "GitHub username for Jenkins access"
  type        = string
  default     = "username"
  sensitive   = true
}

variable "github_token" {
  description = "GitHub token for Jenkins access"
  type        = string
  default     = "token"
  sensitive   = true
}

variable "enable_rbac" {
  description = "Enable RBAC configuration"
  type        = bool
  default     = true
}

variable "enable_casc" {
  description = "Enable Jenkins Configuration as Code"
  type        = bool
  default     = true
}

variable "jenkins_cpu_request" {
  description = "Jenkins CPU request"
  type        = string
  default     = "500m"
}

variable "jenkins_memory_request" {
  description = "Jenkins memory request"
  type        = string
  default     = "1Gi"
}

variable "jenkins_cpu_limit" {
  description = "Jenkins CPU limit"
  type        = string
  default     = "2000m"
}

variable "jenkins_memory_limit" {
  description = "Jenkins memory limit"
  type        = string
  default     = "4Gi"
}

variable "jenkins_storage_size" {
  description = "Jenkins persistent storage size"
  type        = string
  default     = "10Gi"
}

variable "observability_namespace" {
  description = "Namespace for observability components"
  type        = string
  default     = "observability"
}
variable "infra_namespace" {
  description = "Namespace for infrastructure components"
  type        = string
  default     = "infra"
}
variable "developer_namespace" {
  description = "Namespace for development components"
  type        = string
  default     = "developer"
}
