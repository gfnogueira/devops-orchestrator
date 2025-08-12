terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "devops-orchestrator/infra-cluster/observability-alerts/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://minio.infra.svc.cluster.local:9000"
    access_key                  = "minioadmin"
    secret_key                  = "minioadmin123"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
