resource "helm_release" "nginx" {
  name             = "nginx-chart"
  namespace        = "bunch-test"
  create_namespace = true
  chart = "${path.root}/nginx-chart"
  values           = [file("${path.module}/values.yaml")]
}
