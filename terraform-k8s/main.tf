module "namespace" {
  source    = "./modules/namespace"
  name      = var.namespace
}

module "deployment" {
  source         = "./modules/deployment"
  namespace      = module.namespace.name
  image          = var.image
  replicas       = var.replicas
}

module "service" {
  source         = "./modules/service"
  namespace      = module.namespace.name
  app_label      = module.deployment.app_label
}

module "hpa" {
  source         = "./modules/hpa"
  namespace      = module.namespace.name
  deployment     = module.deployment.name
}
