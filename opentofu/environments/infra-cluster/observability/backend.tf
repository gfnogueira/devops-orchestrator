################################################################################
# S3 BACKEND (MINIO) - REMOTE STATE CONFIGURATION
################################################################################
# S3 backend using MinIO to persist state
# for OpenTofu/Terraform between Jenkins pipeline runs.

terraform {
  backend "s3" {
    # MinIO endpoint (internal to the cluster)
    endpoint = "http://minio.infra.svc.cluster.local:9000"
    
    # Bucket and key configuration
    bucket = "terraform-state"
    key    = "devops-orchestrator/infra-cluster/observability/terraform.tfstate"
    region = "us-east-1"  # MinIO accepts any region
    
    # MinIO credentials (default for demo)
    access_key = "minioadmin"
    secret_key = "minioadmin123"
    
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
