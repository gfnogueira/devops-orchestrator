# ============================================================================== 
# PROMETHEUS STACK CUSTOM VALUES
# ==============================================================================
# Template to customize the Prometheus Stack chart
# Used by the observability module

## Prometheus configuration
prometheus:
  # Ingress for Prometheus
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - prometheus.local
    paths:
      - /
    pathType: Prefix

  prometheusSpec:
    # Data retention
    retention: "${retention_days}d"
    retentionSize: "10GiB"
    
    # Resources
    resources:
      requests:
        memory: "512Mi"
        cpu: "200m"
      limits:
        memory: "2Gi"
        cpu: "1000m"
    
    # Storage
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: "standard"
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: "10Gi"

    
    # Monitor selectors - ALLOW ALL to fetch ConfigMaps
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    ruleSelectorNilUsesHelmValues: false
    
    # Select PrometheusRules in all namespaces
    ruleSelector: {}
    ruleNamespaceSelector: {}

    # Custom scrape configs
    additionalScrapeConfigs: |
      - job_name: 'flask-apps'
        kubernetes_sd_configs:
          - role: pod
            namespaces:
              names:
                - dev-apps
                - staging-apps
                - prod-apps
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: "true"
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)


## ================= ALERT RULES =====================
# Enables search for PrometheusRules in all namespaces
prometheusRule:
  enabled: true
    

## Grafana configuration
grafana:
  enabled: true
  
  # Admin credentials
  adminPassword: ${grafana_password}
  
  # Persistence
  persistence:
    enabled: true
    size: "2Gi"
    storageClassName: "standard"
  
  # Resources
  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  
  # Automatic dashboards
  sidecar:
    dashboards:
      enabled: true
      searchNamespace: ALL
      label: grafana_dashboard
      labelValue: "1"
      folderAnnotation: grafana_folder
      provider:
        foldersFromFilesStructure: true
        allowUiUpdates: true
    datasources:
      enabled: true
      searchNamespace: ALL
    # Sidecar para alert rules customizadas (ConfigMaps)
    alerts:
      enabled: true
      searchNamespace: ALL
      label: prometheus_rule
  
  # Pre-configured dashboards
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'devops-dashboards'
        orgId: 1
        folder: 'Devops Monitoring'
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/devops

  dashboards:
    devops-dashboards:
      infrastructure:
        gnetId: null
        revision: 1
        datasource: Prometheus
        json: |
          ${indent(10, file("${path}/dashboards/infrastructure.json"))}
      jenkins:
        gnetId: null
        revision: 1
        datasource: Prometheus  
        json: |
          ${indent(10, file("${path}/dashboards/jenkins.json"))}
      flask-application:
        gnetId: null
        revision: 1
        datasource: Prometheus
        json: |
          ${indent(10, file("${path}/dashboards/flask-application.json"))}
  
  # Useful plugins
  plugins:
    - grafana-piechart-panel
    - grafana-worldmap-panel
    - grafana-clock-panel
  
  # Network settings + Ingress
  service:
    type: ClusterIP
    port: 80
  
  # Ingress for Grafana
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - grafana.local
    tls: []

## AlertManager configuration
alertmanager:
  enabled: true
  
  alertmanagerSpec:
    resources:
      requests:
        memory: "64Mi"
        cpu: "10m"
      limits:
        memory: "256Mi"
        cpu: "100m"
    
    # FIX: Use emptyDir to solve Minikube issue
    storage: {}
    
    # Email configuration for alerts
    config:
      global:
        smtp_smarthost: 'localhost:587'
        smtp_from: 'alertmanager@devops-orchestrator.local'
        smtp_auth_username: 'alertmanager@devops-orchestrator.local'
        smtp_auth_password: 'changeme'
      
      route:
        group_by: ['alertname']
        group_wait: 10s
        group_interval: 10s
        repeat_interval: 1h
        receiver: 'web.hook'
      
      receivers:
        - name: 'web.hook'
          email_configs:
            - to: 'admin@devops-orchestrator.local'
              subject: '🚨 Alert: {{ .GroupLabels.alertname }}'
              body: |
                {{ range .Alerts }}
                Alert: {{ .Annotations.summary }}
                Description: {{ .Annotations.description }}
                {{ end }}

  # Ingress for AlertManager
  ingress:
    enabled: true
    className: nginx
    hosts:
      - alertmanager.local
    tls: []

## Node Exporter
nodeExporter:
  enabled: true

## Kube State Metrics
kubeStateMetrics:
  enabled: true

## Prometheus Operator
prometheusOperator:
  enabled: true
  resources:
    requests:
      memory: "32Mi"
      cpu: "10m"
    limits:
      memory: "128Mi"
      cpu: "100m"

## Default rules
defaultRules:
  create: true
  rules:
    alertmanager: true
    etcd: false  # Disabled for Minikube
    configReloaders: true
    general: true
    k8s: true
    kubeApiserverAvailability: true
    kubeApiserverBurnrate: true
    kubeApiserverHistogram: true
    kubeApiserverSlos: true
    kubelet: true
    kubeProxy: false  # Disabled for Minikube
    kubePrometheusGeneral: true
    kubePrometheusNodeRecording: true
    kubernetesApps: true
    kubernetesResources: true
    kubernetesStorage: true
    kubernetesSystem: true
    network: true
    node: true
    nodeExporterAlerting: true
    nodeExporterRecording: true
    prometheus: true
    prometheusOperator: true
