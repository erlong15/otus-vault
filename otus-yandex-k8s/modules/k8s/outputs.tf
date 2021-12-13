
output "external_v4_endpoint" {
  value       = yandex_kubernetes_cluster.kube_master.master[0].external_v4_endpoint
  description = "External endpoint that can be used to access Kubernetes cluster API from the internet (outside of the cloud)."
}

output "ca_certificate" {
  value       = yandex_kubernetes_cluster.kube_master.master[0].cluster_ca_certificate
  description = "PEM-encoded public certificate that is the root of trust for the Kubernetes cluster."
  sensitive   = true
}
