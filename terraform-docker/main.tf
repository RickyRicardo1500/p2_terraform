terraform {
  required_providers {
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

module "network" {
  source       = "./modules/network"
  network_name = "demo-net"
}

module "postgres" {
  source      = "./modules/postgres"
  db_user     = var.db_user
  db_password = var.db_password
  db_name     = var.db_name
  network     = module.network.network_name
}

module "backend" {
  source      = "./modules/backend"
  db_user     = var.db_user
  db_password = var.db_password
  db_name     = var.db_name
  network     = module.network.network_name
}

module "frontend" {
  source  = "./modules/frontend"
  network = module.network.network_name
}
