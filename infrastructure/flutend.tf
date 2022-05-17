resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/containerinsights/${var.eks.name}/application"
  retention_in_days = 30
  tags              = local.common_tags
}

resource "kubernetes_namespace" "cloudwatch" {
  metadata {
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch",
      "name"      = "amazon-cloudwatch"
    }
    name = "amazon-cloudwatch"
  }
}


resource "kubernetes_service_account" "fluentd" {
  metadata {
    name = "fluentd"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
    namespace = "amazon-cloudwatch"
  }
}

resource "kubernetes_cluster_role" "fluentd" {
  metadata {
    name = "fluentd-role"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "pods/logs"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "fluentd" {
  metadata {
    name = "fluentd-role-binding"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fluentd-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "fluentd"
    namespace = "amazon-cloudwatch"
  }
}

resource "kubernetes_config_map" "fluentd" {
  metadata {
    name      = "fluentd-config"
    namespace = "amazon-cloudwatch"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
  }
  data = {
    "fluent.conf"     = file("${path.module}/fluentd/fluent.conf")
    "containers.conf" = file("${path.module}/fluentd/containers.conf")
    "systemd.conf"    = file("${path.module}/fluentd/systemd.conf")
    "host.conf"       = file("${path.module}/fluentd/host.conf")
  }
}

resource "kubernetes_config_map" "cluster-info" {
  metadata {
    name      = "cluster-info"
    namespace = "amazon-cloudwatch"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
  }
  data = {
    "cluster.name" = var.eks.name
    "logs.region"  = data.aws_region.current.name
  }
}

resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name      = "fluentd-cloudwatch"
    namespace = "amazon-cloudwatch"
    labels = {
      "k8s-addon" = "fluentd-cloudwatch.addons.k8s.io",
      "k8s-app"   = "fluentd-cloudwatch"
    }
  }
  spec {
    selector {
      match_labels = {
        "k8s-app" = "fluentd-cloudwatch"
      }
    }

    template {
      metadata {
        labels = {
          "k8s-app" = "fluentd-cloudwatch"
        }
        annotations = {
          "configHash" = "8915de4cf9c3551a8dc74c0137a3e83569d28c71044b0359c2578d2e0461825"
        }
      }
      spec {
        service_account_name             = "fluentd"
        automount_service_account_token  = true
        termination_grace_period_seconds = 30
        init_container {
          name  = "copy-fluentd-config"
          image = "busybox"
          command = [
            "sh",
            "-c",
            "cp /config-volume/..data/* /fluentd/etc"
          ]
          volume_mount {
            name       = "config-volume"
            mount_path = "/config-volume"
          }
          volume_mount {
            name       = "fluentdconf"
            mount_path = "/fluentd/etc"
          }
        }
        init_container {
          name  = "update-log-driver"
          image = "busybox"
          command = [
            "sh",
            "-c",
            ""
          ]
        }
        container {
          name  = "fluentd-cloudwatch"
          image = var.eks.fluentd_image_location
          env {
            name = "REGION"
            value_from {
              config_map_key_ref {
                name = "cluster-info"
                key  = "logs.region"
              }
            }
          }
          env {
            name = "CLUSTER_NAME"
            value_from {
              config_map_key_ref {
                name = "cluster-info"
                key  = "cluster.name"
              }
            }
          }
          env {
            name  = "CI_VERSION"
            value = "k8s/1.1.1"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              memory = "400Mi"
            }
          }
          volume_mount {
            name       = "config-volume"
            mount_path = "/config-volume"
          }
          volume_mount {
            name       = "fluentdconf"
            mount_path = "/fluentd/etc"
          }
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }
          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = "true"
          }
          volume_mount {
            name       = "runlogjournal"
            mount_path = "/run/log/journal"
            read_only  = "true"
          }
          volume_mount {
            name       = "dmesg"
            mount_path = "/var/log/dmesg"
            read_only  = "true"
          }
        }
        volume {
          name = "config-volume"
          config_map {
            name = "fluentd-config"
          }
        }
        volume {
          name = "fluentdconf"
          empty_dir {}
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "runlogjournal"
          host_path {
            path = "/run/log/journal"
          }
        }
        volume {
          name = "dmesg"
          host_path {
            path = "/var/log/dmesg"
          }
        }
      }
    }
  }
}
