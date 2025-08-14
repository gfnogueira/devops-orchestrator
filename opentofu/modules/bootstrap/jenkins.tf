################################################################################
# JENKINS HELM DEPLOYMENT (Hybrid Master/Agent Architecture)
################################################################################
# Master: Official Jenkins image (with CasC plugins)
# Agents: Custom image (with DevOps tools)
# CasC: Configuration managed via configScripts (inline in Helm)

# Admin credentials for Jenkins
resource "kubernetes_secret" "jenkins_admin" {
  metadata {
    name      = "jenkins-admin-credentials"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = {
      "app.kubernetes.io/name"     = "jenkins"
      "app.kubernetes.io/component" = "controller"
    }
  }

  data = {
    "jenkins-admin-user"     = "admin"
    "jenkins-admin-password" = "admin"
  }

  type = "Opaque"
}

## GitHub credentials for Jenkins to access repositories
resource "kubernetes_secret" "github_credentials" {
  metadata {
    name      = "github-credentials"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    username = var.github_username
    token    = var.github_token
  }

  type = "Opaque"
}

# Jenkins Master via Official Helm Chart
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.75"  # Stable version with CasC
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  timeout = 600  # 10 minutes for install
  wait    = true

  values = [
    yamlencode({
      controller = {
        # Official Jenkins image with plugins
        image = {
          repository = "jenkins/jenkins"
          tag        = "lts"
        }
        
        # Security Context
        securityContext = {
          runAsUser = 0  # Root for init
          fsGroup   = 1000
        }
        containerSecurityContext = {
          runAsUser = 0
          runAsGroup = 1000
          readOnlyRootFilesystem = false
          allowPrivilegeEscalation = true
        }

        podSecurityContextOverride = {
          runAsUser = 0
          runAsNonRoot = false
          supplementalGroups = [0]
        }

        initContainerSecurityContext = {
          runAsUser = 1000
          runAsGroup = 1000
          fsGroup = 1000
        }
        podSecurityContext = {
          fsGroup = 1000
        }    

        # Admin user configuration (init setup helm)
        admin = {
          existingSecret = kubernetes_secret.jenkins_admin.metadata[0].name
          userKey        = "jenkins-admin-user"
          passwordKey    = "jenkins-admin-password"
        }
        
        # ServiceAccount (Helm creates automatically)
        serviceAccount = {
          create = true  # Helm create
          name   = "jenkins"
        }

#        installPlugins = [
#          "configuration-as-code",
#          "pipeline-stage-view",
#          "kubernetes", 
#          "workflow-aggregator",
#          "matrix-auth",
#          "job-dsl",
#          "git"
#        ]

        initScripts = []
        
        JCasC = {
          enabled = true
          defaultConfig = false  # inline customization
          configScripts = {
            jenkins-config = file("${path.module}/../../../jenkins/casc/jenkins.yaml")
          }
        } 

        initContainerEnv = [
          { 
            name = "_JAVA_OPTIONS",
            value = "-Djsse.enableSNIExtension=true" 
          },
          { name = "JENKINS_UC",            value = "https://updates.jenkins.io/update-center.actual.json" },
          { name = "JENKINS_PLUGIN_INFO",   value = "https://updates.jenkins.io/current/plugin-versions.json" },
          { name = "JENKINS_UC_DOWNLOAD_URL", value = "https://mirror.azure.jenkins.io" },
          { name = "NO_PROXY",              value = "updates.jenkins.io,.jenkins.io,.fastly.net" }
          
        ]

        javasOpts = "-Djsse.enableSNIExtension=true"

        containerEnv = [
          {
            name = "GITHUB_USERNAME"
            valueFrom = {
              secretKeyRef = {
                name = "github-credentials"
                key  = "username"
              }
            }
          },
          {
            name = "GITHUB_TOKEN"
            valueFrom = {
              secretKeyRef = {
                name = "github-credentials"
                key  = "token"
              }
            }
          },
          {
            name = "NO_PROXY"
            value = "updates.jenkins.io,.jenkins.io,.fastly.net"
          }
        ]

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
          limits = {
            cpu    = "2"
            memory = "4Gi"
          }
        }
        
        # Jenkins URL for agents
        jenkinsUrl = "http://jenkins.${kubernetes_namespace.jenkins.metadata[0].name}.svc.cluster.local:8080"
      }

      # NOTE: Pod agents are managed via CasC (jenkins.yaml)

      # Persistence
      persistence = {
        enabled = true
        size    = "8Gi"
        storageClass = "standard"
      }

      # Service Account and RBAC
      rbac = {
        create = true  # Helm create ServiceAccount + RBAC
        readSecrets = true  # Necessary for secrets and configmaps
      }
    })
  ]

  depends_on = [
    kubernetes_secret.jenkins_admin,
  ]
}
