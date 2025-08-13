locals {
  cluster_name = "infra-cluster"
  environment  = "infra"
}

################################################################################
# BOOTSTRAP MODULE - Jenkins + Kubernetes Components
################################################################################

module "bootstrap" {
  source = "../../modules/bootstrap"
  
  cluster_name          = local.cluster_name
  environment           = local.environment
  jenkins_namespace     = "jenkins"
  observability_namespace  = "observability"
  infra_namespace       = "infra"
  developer_namespace   = "developer"
  github_username       = var.github_username
  github_token          = var.github_token

  depends_on = [ 
    null_resource.minikube_cluster,
    null_resource.minikube_tunnel 
  ]
}
