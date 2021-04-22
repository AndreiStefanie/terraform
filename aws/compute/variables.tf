variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "public_sg" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "volume_size" {
  type = number
}