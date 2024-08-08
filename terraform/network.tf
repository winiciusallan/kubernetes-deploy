# The configuration of your network must be describe below
# Depends on how your infrastructure is structured

data "openstack_networking_network_v2" "cluster_network" {
  status               = "active"
  external             = false
  matching_subnet_cidr = var.nodes_ip_cidr
}