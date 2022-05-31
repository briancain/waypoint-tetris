project = "docker-tetris-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

variable "image" {
  default     = "tetris"
  type        = string
  description = "Image name for the built image in the Docker registry."
}


app "tetris" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {
    }
  }
}
