



resource "helm_release" "fluent_bit" {
  name             = "fluent-bit"
  namespace        = "logging"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  version          = "0.52.0"
  values           = [file("${path.module}/values.yaml")]
}
