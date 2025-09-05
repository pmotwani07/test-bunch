resource "helm_release" "kibana" {
  name             = "kibana"
  namespace        = "monitoring"
  create_namespace = true   # <- allow Helm/Terraform to create it
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  version          = "8.5.1"
  values           = [file("${path.module}/values.yaml")]
  cleanup_on_fail = true
  force_update = true
  recreate_pods = true
  dependency_update = true
}
