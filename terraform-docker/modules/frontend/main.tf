resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "frontend" {
  name  = "nginx-frontend"
  image = docker_image.nginx.latest

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "${path.module}/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }

  networks_advanced {
    name = var.network
  }
}
