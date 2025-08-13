# Default Credentials (Dev Environment)

| Service   | User         | Password                           |
|-----------|--------------|------------------------------------|
| MinIO     | minioadmin   | minioadmin123                      |
| Jenkins   | admin        | admin                              |
| Grafana   | admin        | (variable "grafana_admin_password" |
|           |              | default = "prom-operator")         |
| GitHub    |   -          | (use your token)                   |

> **Warning:**
> - Never use these passwords in production!
> - Change the default credentials before exposing any service.
> - GitHub tokens should be created manually and never versioned.
