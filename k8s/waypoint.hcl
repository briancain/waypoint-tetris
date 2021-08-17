project = "nginx-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

variable "registry_image" {
  default     = "tetris"
  type        = string
  description = "Image name for the built image in the Docker registry."
}

variable "registry_local" {
  default     = true
  type        = bool
  description = "Whether or not to push the built container to a remote registry"
}

app "tetris" {
  build {
    use "docker" {
    }
    registry {
      use "docker" {
        image = var.registry_image
        tag   = "1"
        local = var.registry_local
      }
    }

  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port = 3000
    }
  }
}
