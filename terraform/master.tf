resource "openstack_compute_instance_v2" "masters" {
  count = var.masters_count

  # General configs
  name            = format("%s-${count.index + 1}", var.masters_name)
  image_id        = tolist(data.openstack_images_image_ids_v2.image.ids)[0]
  flavor_id       = data.openstack_compute_flavor_v2.master_flavor.id
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default", openstack_networking_secgroup_v2.master_secgroup.name]

  network {
    name = data.openstack_networking_network_v2.cluster_network.name
  }
}

resource "openstack_networking_secgroup_v2" "master_secgroup" {
  name        = "master-secgroup"
  description = "Security group to masters node"
}

resource "openstack_networking_secgroup_rule_v2" "master_secgroup_api_server_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.master_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "master_secgroup_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.master_secgroup.id
}

# By default, ephemeral disk size is defined in flavor.
# If you want more disk size, you must attach a volume (or boot with).
data "openstack_compute_flavor_v2" "master_flavor" {
  name      = var.master_flavor_name
  vcpus     = var.master_vcpu_count
  ram       = var.master_memory_count
  is_public = true
}