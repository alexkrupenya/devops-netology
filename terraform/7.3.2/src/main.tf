terraform {
  required_version = ">= 1.1.9"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.75"
    }
  }
}

resource "yandex_compute_instance" "test0" {
  count = local.instance_count[terraform.workspace]
  name = "${terraform.workspace}-${count.index}"
  platform_id = "standard-v1"
  zone = "${var.yandex_cloud_zone}"

  resources {
    cores = "${terraform.workspace == "prod" ? 4 : 2}"
    core_fraction = "${terraform.workspace == "prod" ? 20 : 5}"
    memory = "${terraform.workspace == "prod" ? 4 : 2}"
  }

  boot_disk {
    initialize_params {
      image_id = "${var.centos-8-base}"
      type = "network-nvme"
      size = 10
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_test.id
  }
}

resource "yandex_compute_instance" "test1" {
    for_each = local.instance_foreach
    name = "${terraform.workspace}-${each.key}"
    platform_id = "standard-v1"
    zone = "${var.yandex_cloud_zone}"

  resources {
    cores = "${terraform.workspace == "prod" ? 4 : 2}"
    core_fraction = "${terraform.workspace == "prod" ? 20 : 5}"
    memory = "${terraform.workspace == "prod" ? 4 : 2}"
  }

  boot_disk {
    initialize_params {
      image_id = "${var.centos-8-base}"
      type = "network-nvme"
      size = 10
    }
  }

  scheduling_policy {
        preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_test.id
  }

  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_vpc_network" "testnet" {
  name = "netnet-${terraform.workspace}"
}

resource "yandex_vpc_subnet" "subnet_test" {
  name = "subnetnet-${terraform.workspace}"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.testnet.id
  v4_cidr_blocks = ["192.168.32.0/24"]
}

locals {
  instance_count = {
    prod = 2
    stage = 1
  }
}

locals {
  instance_foreach = toset([
    "foreach0",
    "foreach1",
  ])
}