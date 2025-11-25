terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}


resource "docker_network" "custom_net" {
  name = var.network_name
}
