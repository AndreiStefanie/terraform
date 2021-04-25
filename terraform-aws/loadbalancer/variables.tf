variable "public_subnets" {
  type = list(string)
}

variable "public_sg" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "healthy_threshold" {
  type = number
}

variable "unhealthy_threshold" {
  type = number
}

variable "timeout" {
  type = number
}

variable "interval" {
  type = number
}

variable "listener_port" {
  type = number
}
