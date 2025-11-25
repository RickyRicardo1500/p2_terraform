terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_container" "backend" {
  name  = "backend-api"
  image = docker_image.backend.latest

  env = [
    "DB_HOST=postgres-db",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}"
  ]

  networks_advanced {
    name = var.network
  }
}

