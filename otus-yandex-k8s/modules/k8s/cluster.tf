resource "yandex_kubernetes_cluster" "kube_master" {

  name               = var.kubernetes_name
  description        = "${var.kubernetes_name} k8s cluster"
  network_id         = var.network_id
  cluster_ipv4_range = var.cluster_ipv4_range
  service_ipv4_range = var.service_ipv4_range

  master {
    version = var.k8s_master_version
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }

    public_ip = var.master_public_ip

    maintenance_policy {
      auto_upgrade = var.auto_upgrade

      maintenance_window {
        start_time = "02:00:00.000000000"
        duration   = "2h0m0s"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.service_account.id
  node_service_account_id = yandex_iam_service_account.node_account.id

  depends_on = [
    yandex_iam_service_account.node_account,
    yandex_iam_service_account.service_account,
    yandex_resourcemanager_folder_iam_member.node_account,
    yandex_resourcemanager_folder_iam_member.service_account
  ]

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_key.id
  }
}
