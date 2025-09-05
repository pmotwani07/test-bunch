resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  namespace        = "monitoring"
  create_namespace = true   # <- allow Helm/Terraform to create it
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  version          = "8.5.1"
  values           = [file("${path.module}/values.yaml")]
}
