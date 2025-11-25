resource "docker_network" "network" {
  name = var.network_name
}

output "network_name" {
  value = docker_network.network.name
}
