################################################################################
# BOOTSTRAP MODULE - Jenkins + Governança
################################################################################

################################################################################
# INFRASTRUCTURE NAMESPACES
################################################################################

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.jenkins_namespace
    labels = {
      "purpose"     = "ci-cd"
      "managed-by"  = "opentofu"
      "environment" = "infrastructure"
    }
    annotations = {
      "opentofu/module" = "bootstrap"
    }
  }
}

resource "kubernetes_namespace" "infra" {
  metadata {
    name = var.infra_namespace
    labels = {
      "purpose"     = "infra"
      "managed-by"  = "opentofu"
      "environment" = "infrastructure"
    }
    annotations = {
      "opentofu/module" = "bootstrap"
    }
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = var.observability_namespace
    labels = {
      "purpose"     = "observability"
      "managed-by"  = "opentofu"
      "environment" = "infrastructure"
    }
    annotations = {
      "opentofu/module" = "bootstrap"
    }
  }
}

resource "kubernetes_namespace" "developer" {
  metadata {
    name = var.developer_namespace
    labels = {
      "purpose"     = "development"
      "managed-by"  = "opentofu"
      "environment" = "infrastructure"
    }
    annotations = {
      "opentofu/module" = "bootstrap"
    }
  }
}
