resource "docker_image" "postgres" {
  name = "postgres:15"
}

resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5432
    external = 5432
  }
}
