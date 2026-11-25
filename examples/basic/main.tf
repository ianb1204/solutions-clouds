terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.7"
    }
  }
}

provider "docker" {}

module "nginx" {
  source = "../.."

  image           = "nginx:latest"
  memory          = 128
  privileged      = false
  container_count = 3
  name_prefix     = "web"
  start_port      = 3000
}

output "urls" {
  value = module.nginx.urls
}

output "hostnames" {
  value = module.nginx.hostnames
}
