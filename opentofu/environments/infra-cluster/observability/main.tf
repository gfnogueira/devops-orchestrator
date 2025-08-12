locals {
  cluster_name = "infra-cluster"
  environment  = "infra"
}

# ==============================================================================
# OBSERVABILITY MODULE - Prometheus + Grafana (Helm Provider)
# ==============================================================================

module "observability" {
  source = "../../../modules/observability"
  
  cluster_name         = local.cluster_name
  environment          = local.environment
  monitoring_namespace = "monitoring"
  
  prometheus_enabled   = true
  grafana_enabled      = true
  alertmanager_enabled = true
}
