variable "env" {
  type        = string
  description = "The environment"
  default     = "dev"
  
  validation {
    condition = contains(["dev", "prod"], var.env)
    error_message = "Allowed env values are 'dev' and 'prod'."
  }
}

variable "image" {
  type        = map(any)
  description = "The Docker image"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "container_count" {
  type        = number
  default     = 1
  description = "How many node RED containers to create"

  validation {
    condition     = var.container_count >= 1 && var.container_count <= 10
    error_message = "The count must be between 1 and 10."
  }
}
