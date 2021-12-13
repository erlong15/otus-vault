terraform {
  required_version = ">= 1.0.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "otus-tfstate"
    region   = "ru-central1"
    key      = "environments/otus/k8s/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.yc_token
}
