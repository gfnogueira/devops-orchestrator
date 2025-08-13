################################################################################
# MINIO - S3 Backend for Terraform/OpenTofu state
################################################################################

resource "helm_release" "minio" {
  name       = "minio"
  namespace  = var.infra_namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "minio"
  version    = "13.7.2" # Stable version of MinIO

  create_namespace = false

  values = [
    <<-EOF
    mode: standalone
    auth:
      rootUser: "minioadmin"
      rootPassword: "minioadmin123"
    defaultBuckets: "terraform-state"
    service:
      type: ClusterIP
      ports:
        api: 9000
        console: 9001
    ingress:
      enabled: false
    persistence:
      enabled: true
      size: 5Gi
    containerSecurityContext:
      enabled: true
      runAsUser: 1001
      runAsGroup: 1001
      runAsNonRoot: true
      readOnlyRootFilesystem: false
    podSecurityContext:
      enabled: true
      fsGroup: 1001
    volumePermissions:
      enabled: true
    EOF
  ]

  # Wait for the namespace to exist
  depends_on = [
    kubernetes_namespace.observability
  ]
}

output "minio_service" {
  description = "Serviço MinIO para backend S3 do Terraform/OpenTofu"
  value = {
    name      = helm_release.minio.name
    namespace = var.infra_namespace
    port      = 9000
    user      = "minioadmin"
    password  = "minioadmin123"
    bucket    = "terraform-state"
    url       = "http://minio.127.0.0.1.nip.io"
    endpoint  = "minio.${var.infra_namespace}.svc.cluster.local:9000"
  }
}
