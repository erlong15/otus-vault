resource "yandex_iam_service_account" "service_account" {
  name = "service-account-${var.kubernetes_name}"
}

resource "yandex_iam_service_account" "node_account" {
  name = "node-account-${var.kubernetes_name}"
}

data "yandex_resourcemanager_folder" "folder" {
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "service_account" {
  folder_id = data.yandex_resourcemanager_folder.folder.id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.service_account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "node_account" {
  folder_id = data.yandex_resourcemanager_folder.folder.id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.node_account.id}"
}
