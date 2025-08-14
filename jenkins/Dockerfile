# Inbound agent (JNLP). This image has a multi-arch manifest (includes amd64).
FROM jenkins/jenkins:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV GO_VERSION=1.21.0 \
    CONFTEST_VERSION=0.62.0 \
    TERRAFORM_DOCS_VERSION=0.17.0 \
    TOFU_VERSION=1.10.3 \
    PATH="/usr/local/go/bin:${PATH}"

# Basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl unzip git gnupg wget lsb-release make build-essential bash \
    && rm -rf /var/lib/apt/lists/*

# Go (amd64)
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
 && rm go${GO_VERSION}.linux-amd64.tar.gz \
 && /usr/local/go/bin/go version

# tflint (script detects architecture)
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash \
 && tflint --version

# conftest (uses Linux_x86_64 suffix)
RUN wget -q https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
 && tar -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz -C /usr/local/bin conftest \
 && rm conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
 && conftest --version

# terraform-docs (linux-amd64)
RUN wget -q https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
 && tar -xzf terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
 && mv terraform-docs /usr/local/bin/ \
 && rm terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
 && terraform-docs --version

# OpenTofu + kubectl (both amd64)
RUN wget -q https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.tar.gz \
 && tar -xzf tofu_${TOFU_VERSION}_linux_amd64.tar.gz \
 && mv tofu /usr/local/bin/tofu \
 && ln -sf /usr/local/bin/tofu /usr/local/bin/opentofu \
 && rm tofu_${TOFU_VERSION}_linux_amd64.tar.gz \
 && curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && tofu version \
 && kubectl version --client=true

USER jenkins

# docker build -t TEUIDDOCKERHUB/NOMEDAIMAGE:latest  .