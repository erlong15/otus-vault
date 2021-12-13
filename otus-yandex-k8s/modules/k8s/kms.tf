resource "yandex_kms_symmetric_key" "kms_key" {
  name              = "kms-key-${var.kubernetes_name}"
  description       = "Key for k8s nodes"
  default_algorithm = "AES_256"

}