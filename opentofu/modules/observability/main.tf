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
  namespace  = var.monitoring_namespace

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
    namespace = var.monitoring_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Applications"
    }
  }

  data = {
    "flask-app-dashboard.json" = file("${path.module}/dashboards/flask-app-dashboard.json")
  }

  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "infrastructure_dashboard" {
  metadata {
    name      = "infrastructure-dashboard"
    namespace = var.monitoring_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Infrastructure"
    }
  }

  data = {
    "infrastructure-dashboard.json" = file("${path.module}/dashboards/infrastructure-dashboard.json")
  }

  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "infrastructure_professional_dashboard" {
  metadata {
    name      = "infrastructure-professional-dashboard"
    namespace = var.monitoring_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Professional Monitoring"
    }
  }
  data = {
    "infrastructure-professional.json" = jsonencode(jsondecode(file("${path.module}/dashboards/infrastructure-professional.json")).dashboard)
  }
  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "jenkins_professional_dashboard" {
  metadata {
    name      = "jenkins-professional-dashboard"
    namespace = var.monitoring_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Professional Monitoring"
    }
  }
  data = {
    "jenkins-professional.json" = jsonencode(jsondecode(file("${path.module}/dashboards/jenkins-professional.json")).dashboard)
  }
  depends_on = [helm_release.prometheus_stack]
}

resource "kubernetes_config_map" "flask_application_dashboard" {
  metadata {
    name      = "flask-application-dashboard"
    namespace = var.monitoring_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
    annotations = {
      "grafana_folder" = "Professional Monitoring"
    }
  }
  data = {
    "flask-application.json" = jsonencode(jsondecode(file("${path.module}/dashboards/flask-application.json")).dashboard)
  }
  depends_on = [helm_release.prometheus_stack]
}

################################################################################
# WAIT FOR PROMETHEUSRULE CRD
################################################################################

resource "null_resource" "wait_for_prometheusrule_crd" {
  provisioner "local-exec" {
    command = <<EOT
      for i in {1..30}; do
        kubectl get crd prometheusrules.monitoring.coreos.com && exit 0
        echo "Waiting for PrometheusRule CRD to be available..."
        sleep 5
      done
      echo "CRD prometheusrules.monitoring.coreos.com not found after 150s" >&2
      exit 1
    EOT
  }
  depends_on = [helm_release.prometheus_stack]
}

################################################################################
# Alerts for Prometheus (using PrometheusRule)
################################################################################
resource "kubernetes_manifest" "professional_alerts" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"
    metadata = {
      name      = "professional-alerts"
      namespace = var.monitoring_namespace
      labels = {
        "prometheus" = "kube-prometheus"
        "role"       = "alert-rules"
      }
    }
    spec = yamldecode(file("${path.module}/alerts/professional-alerts.yaml"))
  }
  depends_on = [
    helm_release.prometheus_stack,
    null_resource.wait_for_prometheusrule_crd
  ]
}
