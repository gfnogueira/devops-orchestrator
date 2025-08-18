# Inbound agent (JNLP). This image has a multi-arch manifest (includes arm64).
FROM jenkins/inbound-agent:latest-jdk17

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV GO_VERSION=1.21.0 \
    CONFTEST_VERSION=0.62.0 \
    TERRAFORM_DOCS_VERSION=0.17.0 \
    TOFU_VERSION=1.10.3 \
    PATH="/usr/local/go/bin:${PATH}"

# Basic packages + Docker
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl unzip git gnupg jq wget lsb-release make build-essential bash \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Go (arm64)
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz \
 && tar -C /usr/local -xzf go${GO_VERSION}.linux-arm64.tar.gz \
 && rm go${GO_VERSION}.linux-arm64.tar.gz \
 && /usr/local/go/bin/go version

# tflint (script detects architecture)
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash \
 && tflint --version

# --- Install tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# --- Install checkov
RUN pip install --break-system-packages checkov

# --- Install OPA CLI
RUN curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_arm64_static \
    && chmod +x opa && mv opa /usr/local/bin/

# conftest (uses Linux_arm64 suffix)
RUN wget -q https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz \
 && tar -xzf conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz -C /usr/local/bin conftest \
 && rm conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz \
 && conftest --version


# terraform-docs (linux-arm64)
RUN wget -q https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-arm64.tar.gz \
 && tar -xzf terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-arm64.tar.gz \
 && mv terraform-docs /usr/local/bin/ \
 && rm terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-arm64.tar.gz \
 && terraform-docs --version

# OpenTofu + kubectl + helm (all arm64)
RUN wget -q https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_arm64.tar.gz \
 && tar -xzf tofu_${TOFU_VERSION}_linux_arm64.tar.gz \
 && mv tofu /usr/local/bin/tofu \
 && ln -sf /usr/local/bin/tofu /usr/local/bin/opentofu \
 && rm tofu_${TOFU_VERSION}_linux_arm64.tar.gz \
 && curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
 && chmod 700 get_helm.sh \
 && ./get_helm.sh \
 && rm get_helm.sh \
 && tofu version \
 && kubectl version --client=true \
 && helm version

# Add jenkins user to docker group and set up permissions
RUN groupadd -f docker \
 && usermod -aG docker jenkins \
 && newgrp docker

# Cleanup
RUN rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && rm -rf /usr/local/go/pkg/* \
 && rm -rf /usr/local/go/src/* \
 && rm -rf /usr/local/go/bin/*_test \
 && rm -rf /usr/local/go/pkg/tool/linux_arm64 \
 && rm -rf /usr/local/go/pkg/obj \
 && rm -rf /usr/local/go/pkg/cmd \      
 && apt-get purge -y build-essential make \
 && apt-get autoremove -y

USER jenkins