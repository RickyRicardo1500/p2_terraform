resource "docker_image" "backend" {
  name = "simple-backend:latest"

  build {
    context = "${path.module}"
  }
}

resource "docker_container" "backend" {
  name  = "backend"
  image = docker_image.backend.image_id

  env = [
  "DB_HOST=${var.db_host}",
  "REDIS_HOST=${var.redis_host}"
  ]

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5000
    external = 5000
  }
}

output "container_name" {
  value = docker_container.backend.name
}
