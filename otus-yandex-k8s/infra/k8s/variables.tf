variable "zone" {
  type        = string
  description = "The default availability zone to operate under, if not specified by a given resource."
}

variable "cloud_id" {
  type        = string
  description = "The ID of the cloud to apply any resources to."
}

variable "folder_id" {
  type        = string
  description = "The ID of the folder to operate under, if not specified by a given resource."
}

variable "yc_token" {
  type        = string
  description = "Security token or IAM token used for authentication in Yandex.Cloud. This can also be specified using environment variable YC_TOKEN."
  sensitive   = true
}

variable "network_id" {
  type        = string
  description = "ID of VPC network"
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet in target VPC"
}

variable "kubernetes_name" {
  description = "Name of k8s cluster"
  type        = string
}

variable "disk_size" {
  type        = number
  description = "The size of the disk in GB. Allowed minimal size: 64 GB"
}

variable "public_key" {
  type        = string
  description = "Public key for nodes in Kubernetes cluster"
  default     = ""
}

variable "k8s_master_version" {
  type        = string
  description = "Version of the kubernetes master in YC"
}

variable "k8s_nodes_version" {
  type        = string
  description = "Version of the kubernetes nodes group in YC"
}

variable "auto_scale_min" {
  type        = number
  default     = 1
  description = "A minimum number of nodes to auto scaling"
}

variable "auto_scale_max" {
  type        = number
  default     = 1
  description = "A maximum number of nodes to auto scaling"
}

variable "cores" {
  type        = number
  default     = 1
  description = "Set a number of vcpu's cores"
}

variable "memory" {
  type        = number
  default     = 4
  description = "Set memory volume"
}

variable "core_fraction" {
  type        = number
  default     = 50
  description = "Set vcpu's core fraction"
}

variable "auto_upgrade" {
  type        = bool
  default     = false
  description = "Auto upgrade policy"
}

variable "auto_repair" {
  type        = bool
  default     = true
  description = "Auto repair nodes"
}

variable "master_public_ip" {
  type        = bool
  default     = true
  description = "Create public ip address for master"
}

variable "platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Nodes platform id"
}

variable "nat_nodes" {
  type        = bool
  default     = false
  description = "Configure NAT for nodes"
}

variable "disk_type" {
  type        = string
  default     = "network-ssd"
  description = "Configure disk type"
}

variable "preemtible" {
  type        = bool
  default     = false
  description = "Preemtible nodes"
}

variable "cluster_ipv4_range" {
  type        = string
  description = "Cluster ipv4 range"
}

variable "service_ipv4_range" {
  type        = string
  description = "Service ipv4 range"
}

variable "node_groups" {
  type = map(object(
    {
      name           = string
      zone_ng        = string
      auto_scale_max = number
      auto_scale_min = number
      cores          = number
      core_fraction  = number
      memory         = number
      subnet_zone    = string
      node_taints    = list(string)
      node_labels    = map(string)
      maintenance_window = map(object({
        day        = string
        duration   = string
        start_time = string
      }))
    }
  ))
  default = {}
}
