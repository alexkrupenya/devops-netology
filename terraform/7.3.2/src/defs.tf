provider "yandex" {
  token = var.YCTOKEN
  cloud_id = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone = "${var.yandex_cloud_zone}"
}

terraform {
  backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "netology-buck"
  region     = "ru-central1-a"
  key        = "wss/terraform.tfstate"
  access_key = "YCAJ..."
  secret_key = "YCOM......"
  skip_region_validation      = true
  skip_credentials_validation = true
  }
}
