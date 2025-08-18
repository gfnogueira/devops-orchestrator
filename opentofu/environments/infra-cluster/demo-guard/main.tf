resource "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
}

resource "kubernetes_namespace" "invalid" {
  metadata {
    name = "test-xpto" # Does not start with dev-, staging-, or prod-
    labels = {
      # Missing the required label "purpose"
      team = "qa"
    }
  }
}

resource "kubernetes_namespace" "no_labels" {
  metadata {
    name = "dev-app"
    # No labels defined at all
  }
}

resource "kubernetes_secret" "insecure_secret" {
  metadata {
    name = "my-secret"
  }

  data = {
    password = "mySuperSecret123" # Not base64 encoded (plain text)
  }
}