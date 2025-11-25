terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}


resource "docker_image" "postgres" {
  name = "postgres:15"
}

resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = docker_image.postgres.latest

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  volumes {
    container_path = "/var/lib/postgresql/data"
    host_path      = "${path.root}/pgdata"
  }

  networks_advanced {
    name = var.network
  }
}
