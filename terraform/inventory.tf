resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.j2",
    {
      master = {
        index      = range(var.masters_count)
        ip_address = openstack_compute_instance_v2.masters.*.access_ip_v4
        vm_name    = openstack_compute_instance_v2.masters.*.name
      }

      worker = {
        index      = range(var.workers_count)
        ip_address = openstack_compute_instance_v2.workers.*.access_ip_v4
        vm_name    = openstack_compute_instance_v2.workers.*.name
      }
  })
  filename        = "inventory.ini"
  file_permission = "0600"
}