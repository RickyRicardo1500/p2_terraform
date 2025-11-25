module "network" {
  source       = "./modules/network"
  network_name = "demo-net"
}

module "postgres" {
  source       = "./modules/postgres"
  db_user      = var.db_user
  db_password  = var.db_password
  db_name      = var.db_name
  network_name = module.network.network_name
}

module "backend" {
  source       = "./modules/backend"
  network_name = module.network.network_name
  db_host      = module.postgres.container_name
  redis_host   = module.redis.container_name
}


module "frontend" {
  source       = "./modules/frontend"
  network_name = module.network.network_name
  backend_host = module.backend.container_name
}

module "redis" {
  source       = "./modules/redis"
  network_name = module.network.network_name
}
