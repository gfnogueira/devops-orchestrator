terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "infra-cluster"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "infra-cluster"
  }
}