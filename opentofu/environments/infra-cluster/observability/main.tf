locals {
  cluster_name = "infra-cluster"
  environment  = "infra"
}

# ==============================================================================
# OBSERVABILITY MODULE - Prometheus + Grafana (Helm Provider)
# ==============================================================================

module "observability" {
  source = "../../../modules/observability"
  
  cluster_name            = local.cluster_name
  environment             = local.environment
  observability_namespace = "observability"
  
  prometheus_enabled   = true
  grafana_enabled      = true
  alertmanager_enabled = true
}
