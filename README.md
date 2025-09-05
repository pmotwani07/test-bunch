Main Components

Nginx Dockerfile
Docker image built from this Dockerfile is uploaded to my personal Docker repository for testing purposes.
In production scenarios, the image can be fetched from AWS ECR.

Provider Configuration
Contains provider config for Kubernetes providers and Terraform/Helm Providers.

Terraform Configuration (main.tf)
Defines Terraform modules as required.

Nginx Helm Chart
Custom Helm chart for deploying Nginx.

Terraform Directory for Additional Charts
Contains Terraform configurations to deploy additional Helm charts fetched from public repositories, including:

Prometheus

ELK Stack (Elastic Search and Kibana)

Fluent Bit (manual installation on Minikube due to resource/dependency constraints; commands shared in further steps)

Repository Structure

Root level: provider file, main file, Nginx chart, .gitignore

Terraform directory: modules as required

1️⃣ Nginx Dockerfile

Builds a custom Nginx image for the web application.

Uploaded to Docker Hub (pmotwani575/nginx) for test purposes.

In production, the image can be pulled from ECR or any private registry.

nginx.conf is included for custom server configuration.

2️⃣ Terraform Provider Configuration (provider.tf)

Configures Terraform providers for Kubernetes and Helm.

Ensures Helm charts and Kubernetes resources are deployed to the correct cluster (Minikube in this setup).

Example:

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

3️⃣ Main Terraform Configuration (main.tf)

Deploys Helm releases for:

Elasticsearch (official Helm chart)

Kibana (visualization for ES)

Prometheus (metrics collection)

Nginx (custom Helm chart)

Fluent Bit: Installed manually due to Helm provider constraints with nested values and Minikube cluster size.

Manual installation:

cd /terraform/modules/fluent-bit
helm install fluent-bit fluent/fluent-bit \
  --namespace logging \
  --create-namespace \
  -f values.yaml

4️⃣ Nginx Helm Chart (nginx-chart/)

Custom Helm chart for deploying the Nginx web application.

Uses Docker image from pmotwani575/nginx or build locally and push to your repository.

Includes:

Deployment manifest with image and environment variables

Service to expose Nginx

5️⃣ Terraform Modules (modules/)

Each module contains Helm or Terraform configurations for a specific component:

Module	Purpose
elasticsearch/	Deploy Elasticsearch cluster with authentication and TLS
kibana/	Deploy Kibana to visualize Elasticsearch data
prometheus/	Deploy Prometheus for metrics monitoring
fluent-bit/	Fluent Bit for centralized logging (manual Helm install via commands shared above in point 3)
nginx/	Custom Nginx deployment Helm chart

Prometheus, Elasticsearch, and Kibana charts are fetched from public Helm repositories.

Modules are fully modular and reusable.

Deployment Instructions

Start Kubernetes cluster (Minikube or other, min 4 CPUs & 8 GB RAM):

minikube start
kubectl config current-context


Navigate to Terraform directory:

cd test-bunch/terraform


Initialize Terraform providers:

terraform init


Apply Terraform to deploy all modules:

terraform apply


Type yes when prompted.

Terraform will deploy Helm charts for Elasticsearch, Kibana, Prometheus, and Nginx.

Verify deployments:

kubectl get all -n monitoring
kubectl get all -n logging
kubectl get all -n default


Install Fluent Bit manually (if not deployed via Terraform):

helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm install fluent-bit fluent/fluent-bit \
  --namespace logging --create-namespace \
  -f values.yaml


Local Testing Instructions:

Test deployed services via Kubernetes port forwarding.

Example: Prometheus

kubectl port-forward svc/prometheus-server 9090:80

Notes / Important Points

Docker image must be pushed to Docker Hub or private registry before deploying Nginx.

Helm provider version ~> 2.17 is recommended to avoid crashes with nested values.

Fluent Bit is installed manually due to plugin constraints with Terraform Helm provider.

All modules are modular, reusable, and independently upgradable.
