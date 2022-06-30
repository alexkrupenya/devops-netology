terraform {
  required_version = ">= 1.1.9"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.75"
    }
  }

backend "s3" {
  endpoint = "storage.yandexcloud.net"
  bucket = "netology-buck"
  region = "ru-central1-a"
  key = "./terraform.tfstate"
  access_key = "YCA******************"
  secret_key = "YCO******************"
  skip_region_validation = true
  skip_credentials_validation = true
  }
}
