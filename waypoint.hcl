project = "k8s-tetris"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/briancain/waypoint-tetris.git"
    path = ""
  }
}

app "tetris" {
  build {
    use "docker" {
    }
    registry {
      use "docker" {
        image    = var.image
        tag      = var.tag
        username = var.registry_username
        password = var.registry_password
        local    = var.registry_local
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path   = "/"
      image_secret = var.regcred_secret

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
      port          = 3000
    }
  }
}

variable "image" {
  # free tier, old container registry
  #default     = "bcain.jfrog.io/default-docker-virtual/tetris"
  default     = "team-waypoint-dev-docker-local.artifactory.hashicorp.engineering/tetris"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "tag" {
  default     = "latest"
  type        = string
  description = "Image tag for the image"
}

variable "registry_local" {
  default     = false
  type        = bool
  description = "Set to enable local or remote container registry pushing"
}

variable "registry_username" {
  default = dynamic("vault", {
    path = "secret/data/registry"
    key  = "/data/registry_username"
  })
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  default = dynamic("vault", {
    path = "secret/data/registry"
    key  = "/data/registry_password"
  })
  type        = string
  sensitive   = true
  description = "password for registry" // don't hack me plz
}

variable "regcred_secret" {
  default     = "regcred"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}
