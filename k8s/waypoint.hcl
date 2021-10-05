project = "k8s-tetris-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

variable "tag" {
  default     = "latest"
  type        = string
  description = "The tab for the built image in the Docker registry."
}

variable "image" {
  default     = "tetris"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "registry_local" {
  default     = true
  type        = bool
  description = "Whether or not to push the built container to a remote registry"
}

variable "release_port" {
  default     = "3000"
  type        = string
  description = "Port to open for the releaser."
}

variable "namespace" {
  default     = ""
  type        = string
  description = "Namespace to deploy to on a Kubernetes cluster"
}

app "tetris" {
  build {
    use "docker" {
    }
    registry {
      use "docker" {
        image = var.image
        tag   = var.tag
        local = var.registry_local
      }
    }

  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = var.namespace

      cpu {
        request = "250m"
        limit   = "500m"
      }

      memory {
        request = "64Mi"
        limit   = "128Mi"
      }

      autoscale {
        min_replicas = 2
        max_replicas = 5
        cpu_percent  = 50
      }
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = var.release_port

      namespace = var.namespace
    }
  }
}
