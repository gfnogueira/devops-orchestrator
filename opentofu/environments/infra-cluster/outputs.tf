output "jenkins_url" {
  description = "Jenkins URL"
  value       = module.bootstrap.jenkins_url
}

output "jenkins_namespace" {
  description = "Jenkins Namespace"
  value       = module.bootstrap.jenkins_namespace
}

output "minio_service" {
  description = "MinIO Information (S3 backend)"
  value       = module.bootstrap.minio_service
  sensitive   = true
}