variable "container_count" {
  type        = number
  default     = 1
  description = "How many node RED containers to create"

  validation {
    condition     = var.container_count >= 1 && var.container_count <= 10
    error_message = "The count must be between 1 and 10."
  }
}
