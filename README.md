# devops-orchestrator

## How to provision the Minikube cluster and apply the bootstrap

This project uses [OpenTofu](https://opentofu.org/) to provision and manage the infrastructure for the Minikube cluster, as well as install components like Jenkins, Ingress, MinIO, Prometheus, Grafana, and more.

### Step-by-step bootstrap process

1. **Apply the Minikube cluster resource:**
   ```bash
   tofu apply -auto-approve -target=null_resource.minikube_cluster
   ```

2. **Apply the bootstrap and all remaining resources (secrets, tunnel, Jenkins, etc):**
   ```bash
   tofu apply -var="github_username=YOUR_GITHUB_USERNAME" -var="github_token=YOUR_GITHUB_TOKEN" -auto-approve
   ```

> **Note:** You may be prompted for your system's **root password** when setting up the Minikube tunnel required for ingress usage.

---

### Main directory structure

- `opentofu/environments/infra-cluster/` - Main infrastructure for the Minikube cluster
- `opentofu/modules/bootstrap/` - Bootstrap module: Jenkins, Ingress, MinIO, etc
- `opentofu/modules/observability/` - Observability module: Prometheus, Grafana, dashboards

---

### Requirements

- [OpenTofu](https://opentofu.org/) installed
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed
- [Minikube](https://minikube.sigs.k8s.io/docs/) installed

---

### Notes

- The bootstrap installs all essential components for the local DevOps pipeline.
- The `infra-cluster` context will be created automatically after cluster provisioning.
- The second `tofu apply` installs all dependent resources (secrets, Jenkins, ingress, etc).