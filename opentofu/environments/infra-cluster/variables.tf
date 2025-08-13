variable "github_username" {
  description = "GitHub username for Jenkins access"
  type        = string
  default     = "username"
  sensitive   = true
}

variable "github_token" {
  description = "GitHub token for Jenkins access"
  type        = string
  default     = "password"
  sensitive   = true
}
