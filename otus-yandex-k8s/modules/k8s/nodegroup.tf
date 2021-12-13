resource "yandex_kubernetes_node_group" "additional_node_groups" {
  for_each    = var.node_groups
  name        = "node-group-${var.kubernetes_name}-${each.value.name}"
  cluster_id  = yandex_kubernetes_cluster.kube_master.id
  description = "${var.kubernetes_name} k8s cluster node group"
  version     = var.k8s_nodes_version
  node_labels = each.value.node_labels
  node_taints = each.value.node_taints

  instance_template {
    platform_id = var.platform_id

    network_interface {
      nat        = var.nat_nodes
      subnet_ids = ["${each.value.subnet_zone}"]
    }

    resources {
      core_fraction = each.value.core_fraction
      memory        = each.value.memory
      cores         = each.value.cores
    }

    boot_disk {
      type = var.disk_type
      size = var.disk_size
    }

    scheduling_policy {
      preemptible = var.preemtible
    }

    metadata = {
      ssh-keys = var.public_key
    }
  }

  scale_policy {
    auto_scale {
      min     = each.value.auto_scale_min
      max     = each.value.auto_scale_max
      initial = each.value.auto_scale_min
    }
  }

  allocation_policy {
    location {
      zone = each.value.zone_ng
    }
  }

  maintenance_policy {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair

    dynamic "maintenance_window" {
      for_each = each.value.maintenance_window
      content {
        day        = maintenance_window.value["day"]
        start_time = maintenance_window.value["start_time"]
        duration   = maintenance_window.value["duration"]
      }
    }
  }
}

resource "yandex_kubernetes_node_group" "node_group" {
  name        = "node-group-${var.kubernetes_name}"
  cluster_id  = yandex_kubernetes_cluster.kube_master.id
  description = "${var.kubernetes_name} k8s cluster node group"
  version     = var.k8s_nodes_version


  instance_template {
    platform_id = var.platform_id

    network_interface {
      nat        = var.nat_nodes
      subnet_ids = ["${var.subnet_id}"]
    }

    resources {
      core_fraction = var.core_fraction
      memory        = var.memory
      cores         = var.cores
    }

    boot_disk {
      type = var.disk_type
      size = var.disk_size
    }

    scheduling_policy {
      preemptible = var.preemtible
    }

    metadata = {
      ssh-keys = var.public_key
    }
  }

  scale_policy {
    auto_scale {
      min     = var.auto_scale_min
      max     = var.auto_scale_max
      initial = var.auto_scale_min
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair

    maintenance_window {
      day        = "monday"
      start_time = "03:00:00.000000000"
      duration   = "2h0m0s"
    }

    maintenance_window {
      day        = "friday"
      start_time = "04:00:00.000000000"
      duration   = "3h30m0s"
    }
  }
}
