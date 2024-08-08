resource "openstack_compute_keypair_v2" "keypair" {
  name       = "k8s-keypair"
  public_key = file(var.ssh_key_path)
}