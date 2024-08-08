resource "openstack_compute_instance_v2" "workers" {
  count = var.workers_count

  # General configs
  name            = format("%s-${count.index + 1}", var.workers_name)
  image_id        = tolist(data.openstack_images_image_ids_v2.image.ids)[0]
  flavor_id       = data.openstack_compute_flavor_v2.worker_flavor.id
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default", openstack_networking_secgroup_v2.worker_secgroup.name]

  network {
    name = data.openstack_networking_network_v2.cluster_network.name
  }
}

resource "openstack_networking_secgroup_v2" "worker_secgroup" {
  name        = "worker-secgroup"
  description = "Security group to workers node"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.worker_secgroup.id
}

data "openstack_compute_flavor_v2" "worker_flavor" {
  name      = var.worker_flavor_name
  vcpus     = var.worker_vcpu_count
  ram       = var.worker_memory_count
  is_public = true
}