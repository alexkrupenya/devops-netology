resource "yandex_compute_instance" "vmtest01" {
	name = "vmtest01"
	zone = "${var.yandex_cloud_zone}"
	hostname  = "vmtest01.netology.test"
	platform_id = "standard-v3"
	allow_stopping_for_update = true

	resources {
		cores = 2
		memory = 2
	}

	boot_disk {
    initialize_params {
      image_id = "${var.centos-8-base}"
      name = "disk00"
      type = "network-nvme"
      size = "10"
    }
  }

scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat  = true
    ip_address = "192.168.32.32"
  }

  metadata = {
    ssh-keys = "cloud-user:${file("~/.ssh/id_rsa.pub")}"
  }
}
