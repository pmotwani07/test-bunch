resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true   # <- allow Helm/Terraform to create it
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "27.35.0"
  values           = [file("${path.module}/values.yaml")]
}
