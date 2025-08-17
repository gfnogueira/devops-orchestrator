################################################################################
# OBSERVABILITY MODULE - Prometheus + Grafana via Helm
################################################################################

################################################################################
# PROMETHEUS STACK VIA HELM
################################################################################

resource "helm_release" "prometheus_stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"
  namespace  = var.observability_namespace

  create_namespace = false
  wait             = true
  timeout          = 600

  # Custom values for our environment
  values = [
    templatefile("${path.module}/values/prometheus-values.yaml.tpl", {
      retention_days   = var.prometheus_retention_days
      grafana_password = var.grafana_admin_password
      path             = path.module
    })
  ]

  # Specific settings via set (only Grafana password)
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

}

################################################################################
# CUSTOM DASHBOARDS (Kubernetes Provider)
################################################################################

resource "kubernetes_config_map" "flask_dashboard" {
  metadata {
    name      = "flask-app-dashboard"
    namespace = var.observability_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Applications"
    }
  }

  data = {
    "flask-app-dashboard.json" = jsonencode(jsondecode(file("${path.module}/dashboards/flask-app-dashboard.json")).dashboard)
  }

  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "infrastructure_dashboard" {
  metadata {
    name      = "infrastructure-dashboard"
    namespace = var.observability_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Infrastructure"
    }
  }

  data = {
    "infrastructure-dashboard.json" = jsonencode(jsondecode(file("${path.module}/dashboards/infrastructure-dashboard.json")).dashboard)
  }

  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "infrastructure_devops_dashboard" {
  metadata {
    name      = "infrastructure-devops-dashboard"
    namespace = var.observability_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Devops Monitoring"
    }
  }
  data = {
    "infrastructure.json" = jsonencode(jsondecode(file("${path.module}/dashboards/infrastructure.json")).dashboard)
  }
  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "jenkins_dashboard" {
  metadata {
    name      = "jenkins-dashboard"
    namespace = var.observability_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Devops Monitoring"
    }
  }
  data = {
    "jenkins.json" = jsonencode(jsondecode(file("${path.module}/dashboards/jenkins.json")).dashboard)
  }
  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "flask_application_dashboard" {
  metadata {
    name      = "flask-application-dashboard"
    namespace = var.observability_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Devops Monitoring"
    }
  }
  data = {
    "flask-application.json" = jsonencode(jsondecode(file("${path.module}/dashboards/flask-application.json")).dashboard)
  }

  depends_on = [helm_release.prometheus_stack]
}

