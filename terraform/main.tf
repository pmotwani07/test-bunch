module "nginx" {
  source = "./modules/nginx"
}

module "elasticsearch" {
  source = "./modules/elasticsearch"
}

module "kibana" {
  source = "./modules/kibana"
}

module "prometheus" {
  source = "./modules/prometheus"
}
