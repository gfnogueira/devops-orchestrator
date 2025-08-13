################################################################################
# INGRESS FOR JENKINS
################################################################################

resource "kubernetes_ingress_v1" "jenkins_ingress" {
  depends_on = [helm_release.ingress_nginx, helm_release.jenkins]
  
  metadata {
    name      = "jenkins-ingress"
    namespace = var.jenkins_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "3600"
    }
  }

  spec {
    ingress_class_name = "nginx"
    
    rule {
      host = "jenkins.127.0.0.1.nip.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "jenkins"  # Name of the service created by the Helm Chart
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

################################################################################
# INGRESS FOR MINIO
################################################################################

resource "kubernetes_ingress_v1" "minio_ingress" {
  depends_on = [helm_release.ingress_nginx, helm_release.minio]
  
  metadata {
    name      = "minio-ingress"
    namespace = var.infra_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "0"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "600"
    }
  }

  spec {
    ingress_class_name = "nginx"
    
    rule {
      host = "minio.127.0.0.1.nip.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "minio"
              port {
                number = 9001
              }
            }
          }
        }
      }
    }
  }
}
