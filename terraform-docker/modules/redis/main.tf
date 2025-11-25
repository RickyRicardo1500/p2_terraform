terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "redis" {
  name = "redis:7"
}

resource "docker_container" "redis" {
  name  = "redis"
  image = docker_image.redis.image_id

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 6379
    external = 6379
  }
}
