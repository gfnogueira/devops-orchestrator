package main

default allow = true

# --- RULE 1: Forbid changes to the 'default' namespace
deny contains msg if {
  input.resource.metadata.name == "default"
  msg := "❌ It is not allowed to change the 'default' namespace"
}

# --- RULE 2: Application namespaces must start with dev-, staging-, or prod-
deny contains msg if {
  input.resource_type == "kubernetes_namespace"
  name := input.resource.metadata.name
  not valid_app_namespace(name)
  not infra_namespace(name)
  msg := sprintf("❌ Namespace '%s' is invalid. Use prefixes 'dev-', 'staging-', or 'prod-'", [name])
}

# --- RULE 3: Required labels in namespaces
deny contains msg if {
  input.resource_type == "kubernetes_namespace"
  not input.resource.metadata.labels.purpose
  msg := sprintf("❌ Namespace '%s' missing required label 'purpose'", [input.resource.metadata.name])
}

# --- RULE 4: Secrets must not contain plain text data
deny contains msg if {
  input.resource_type == "kubernetes_secret"
  some key, value in input.resource.data
  not custom_base64_encoded(value)
  msg := sprintf("❌ Secret '%s' contains value not properly encoded", [input.resource.metadata.name])
}

# --- AUXILIARY FUNCTIONS

valid_app_namespace(name) if {
  startswith(name, "dev-")
}

valid_app_namespace(name) if {
  startswith(name, "staging-")
}

valid_app_namespace(name) if {
  startswith(name, "prod-")
}

infra_namespace(name) if {
  name == "observability"
}

infra_namespace(name) if {
  name == "jenkins"
}

infra_namespace(name) if {
  name == "kube-system"
}

infra_namespace(name) if {
  name == "default"
}

custom_base64_encoded(value) if {
  is_string(value)
  not contains(value, " ")
}