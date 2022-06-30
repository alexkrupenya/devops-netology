output "internal_ip_address_vmtest01" {
  value = "${yandex_compute_instance.vmtest01.network_interface.0.ip_address}"
}

output "external_ip_address_vmtest01" {
  value = "${yandex_compute_instance.vmtest01.network_interface.0.nat_ip_address}"
}

