locals {
  cluster_name = "infra-cluster"
  environment  = "infra"
}

# ==============================================================================
# OBSERVABILITY ALERTS MODULE - PrometheusRule only
# ==============================================================================

module "observability_alerts" {
  source = "../../../modules/observability-alerts"
  
  cluster_name            = local.cluster_name
  environment             = local.environment
  observability_namespace = "observability"
}
