variable "image" {
  description = "Docker image to run (must be nginx-based for the hostname home page)."
  type        = string
  default     = "nginx:latest"
}

variable "memory" {
  description = "Memory limit per container, in MB."
  type        = number
  default     = 256

  validation {
    condition     = var.memory >= 6 && floor(var.memory) == var.memory
    error_message = "memory must be a whole number of MB, at least 6 (Docker minimum)."
  }
}

variable "privileged" {
  description = "Run the containers in privileged mode."
  type        = bool
  default     = false
}

variable "container_count" {
  description = "Number of containers to spawn."
  type        = number
  default     = 1

  validation {
    condition     = var.container_count >= 1 && floor(var.container_count) == var.container_count
    error_message = "container_count must be a whole number, at least 1."
  }
}

variable "name_prefix" {
  description = "Prefix of the generated container names: <prefix>-1, <prefix>-2, ..."
  type        = string
  default     = "nginx"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]*$", var.name_prefix))
    error_message = "name_prefix must be a valid Docker container name ([a-zA-Z0-9][a-zA-Z0-9_.-]*)."
  }
}

variable "start_port" {
  description = "Host port of the first container; the next ones use start_port + 1, + 2, ..."
  type        = number
  default     = 3000

  validation {
    condition     = var.start_port >= 1 && var.start_port <= 65535 && floor(var.start_port) == var.start_port
    error_message = "start_port must be a whole number between 1 and 65535."
  }
}
