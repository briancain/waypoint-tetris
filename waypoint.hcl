project = "nginx-project"

# Labels can be specified for organizational purposes.
# labels = { "foo" = "bar" }

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
