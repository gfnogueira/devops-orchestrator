resource "kubernetes_cluster_role_binding" "jenkins_cluster_admin" {
  metadata {
    name = "jenkins-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = var.jenkins_namespace
  }
}
