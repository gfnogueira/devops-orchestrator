output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "observability_namespace" {
  description = "Monitoring namespace for observability"
  value       = kubernetes_namespace.observability.metadata[0].name
}

output "jenkins_service_name" {
  description = "Jenkins service name (created by Helm Chart)"
  value       = "jenkins"
}

output "jenkins_url" {
  description = "Jenkins access URL"
  value       = "http://jenkins.${kubernetes_namespace.jenkins.metadata[0].name}.svc.cluster.local:8080"
}

output "jenkins_ingress_url" {
  description = "Jenkins Ingress URL"
  value       = "http://jenkins.127.0.0.1.nip.io"
}

output "ingress_controller_http_port" {
  description = "Ingress Controller HTTP NodePort"
  value       = 30080
}

output "ingress_controller_https_port" {
  description = "Ingress Controller HTTPS NodePort"
  value       = 30443
}

output "jenkins_service_account" {
  description = "Jenkins service account (created by Helm)"
  value       = "jenkins"
}

output "jenkins_helm_release" {
  description = "Jenkins Helm release name"
  value       = helm_release.jenkins.name
}
