package main

# --- EXAMPLES OF KUBERNETES POLICY TESTS ---

# Forbid creation of ClusterRoleBinding with cluster-admin
deny[msg] {
  input.resource_type == "kubernetes_clusterrolebinding"
  some subject in input.resource.subjects
  subject.kind == "User"
  subject.name == "admin"
  input.resource.roleRef.name == "cluster-admin"
  msg := sprintf("❌ ClusterRoleBinding to 'admin' with 'cluster-admin' is forbidden", [])
}

# Forbid Service of type LoadBalancer in dev namespaces
deny[msg] {
  input.resource_type == "kubernetes_service"
  input.resource.spec.type == "LoadBalancer"
  startswith(input.resource.metadata.namespace, "dev-")
  msg := sprintf("❌ Service '%s' in dev namespace cannot be type LoadBalancer", [input.resource.metadata.name])
}

# Require resource limits for all containers in Deployments
deny[msg] {
  input.resource_type == "kubernetes_deployment"
  some container in input.resource.spec.template.spec.containers
  not container.resources.limits
  msg := sprintf("❌ Deployment '%s' container '%s' missing resource limits", [input.resource.metadata.name, container.name])
}

# Forbid use of hostPath volumes in Pods
deny[msg] {
  input.resource_type == "kubernetes_pod"
  some volume in input.resource.spec.volumes
  volume.hostPath
  msg := sprintf("❌ Pod '%s' uses hostPath volume, which is forbidden", [input.resource.metadata.name])
}

# Require annotation 'owner' in all resources
deny[msg] {
  not input.resource.metadata.annotations.owner
  msg := sprintf("❌ Resource '%s' missing required annotation 'owner'", [input.resource.metadata.name])
}

# Forbid privileged containers in any Pod or Deployment
deny[msg] {
  input.resource_type == "kubernetes_pod" or input.resource_type == "kubernetes_deployment"
  some container in input.resource.spec.containers
  container.securityContext.privileged == true
  msg := sprintf("❌ Resource '%s' container '%s' is privileged", [input.resource.metadata.name, container.name])
}

# Forbid use of latest tag in container images
deny[msg] {
  some container in input.resource.spec.containers
  endswith(container.image, ":latest")
  msg := sprintf("❌ Resource '%s' container '%s' uses 'latest' tag in image", [input.resource.metadata.name, container.name])
}
