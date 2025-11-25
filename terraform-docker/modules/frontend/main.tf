terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "frontend" {
  name  = "frontend"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8081
  }

  networks_advanced {
    name = var.network_name
  }
}
