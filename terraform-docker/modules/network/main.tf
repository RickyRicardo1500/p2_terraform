resource "docker_network" "custom_net" {
  name = var.network_name
}
