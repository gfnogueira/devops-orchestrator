################################################################################
# Minikube Cluster Automation (Local)
################################################################################
# Automates Minikube cluster creation and ingress tunnel
################################################################################

provider "local" {}
provider "null" {}

resource "null_resource" "minikube_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      set -e
      echo "[Minikube] Setting driver to docker..."
      minikube config set driver docker
      echo "[Minikube] Starting cluster 'infra-cluster'..."
      #minikube start -p infra-cluster --cpus=2 --memory=4g
      minikube start --profile=infra-cluster --nodes=2 --cpus=2 --memory=4096 --driver=docker
    EOT
  }
}

resource "null_resource" "minikube_tunnel" {
  depends_on = [null_resource.minikube_cluster]
  provisioner "local-exec" {
    command = <<EOT
      echo "[Minikube] Opening tunnel for ingress..."
      nohup minikube tunnel -p infra-cluster > minikube-tunnel.log 2>&1 &
      echo "[Minikube] Tunnel started in background. Log: minikube-tunnel.log"
    EOT
  }
}

output "minikube_status" {
  value = "Run 'minikube status -p infra-cluster' to check cluster health."
}
