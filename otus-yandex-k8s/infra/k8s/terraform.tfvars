zone               = "ru-central1-a"
cloud_id           = "b1ga9aooiodscmmouobm"
folder_id          = "b1g416evp4dl2eef88nt"
network_id         = "enp8mk6f5kt5oercunba"
subnet_id          = "e9bmk8ciimnugftjeac3"
kubernetes_name    = "otus-yandex-k8s"
disk_size          = 64
k8s_master_version = "1.19"
k8s_nodes_version  = "1.19"
auto_scale_min     = 2
auto_scale_max     = 5
core_fraction      = 100
cores              = 4
cluster_ipv4_range = "10.51.0.0/16"
service_ipv4_range = "10.52.0.0/16"
node_groups        = {
}
