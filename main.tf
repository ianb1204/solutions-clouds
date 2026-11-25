locals {
  container_names = [for i in range(var.container_count) : "${var.name_prefix}-${i + 1}"]
}

resource "docker_image" "this" {
  name = var.image

  # Don't delete the image on destroy: other containers (or other
  # configurations using the same image) may still need it.
  keep_locally = true
}

resource "docker_container" "this" {
  count = var.container_count

  name       = local.container_names[count.index]
  image      = docker_image.this.image_id
  memory     = var.memory
  privileged = var.privileged

  # Container n is reachable on start_port + n - 1
  ports {
    internal = 80
    external = var.start_port + count.index
  }

  # Bonus 1: the nginx entrypoint runs every executable *.sh in
  # /docker-entrypoint.d/ at startup; this one writes a home page that
  # shows the container hostname.
  upload {
    file       = "/docker-entrypoint.d/99-hostname-page.sh"
    content    = file("${path.module}/files/hostname-page.sh")
    executable = true
  }

  lifecycle {
    precondition {
      condition     = var.start_port + var.container_count - 1 <= 65535
      error_message = "start_port + container_count - 1 must not exceed 65535."
    }
  }
}
