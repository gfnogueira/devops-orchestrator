################################################################################
# INGRESS CONTROLLER (NGINX)
################################################################################

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.13.0"
  namespace  = var.infra_namespace

  create_namespace = true
  wait             = true
  timeout          = 300

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
        }
        ingressClassResource = {
          default = true
        }
        admissionWebhooks = {
          enabled = false  # For Minikube/macOS
        }
      }
    })
  ]
}