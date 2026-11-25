output "container_names" {
  description = "Names of the spawned containers."
  value       = docker_container.this[*].name
}

output "urls" {
  description = "Map of container name => URL on the host."
  value = {
    for c in docker_container.this : c.name => "http://localhost:${one(c.ports).external}"
  }
}

output "hostnames" {
  description = "Map of container name => container hostname (shown on its home page)."
  value       = { for c in docker_container.this : c.name => c.hostname }
}
