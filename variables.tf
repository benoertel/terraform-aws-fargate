variable "container_definitions_json" {
  type = string
}

variable "container_port" {
  default = 80
  type    = number
}

variable "cpu" {
  default = 256
  type    = number
}

variable "desired_count" {
  default = 1
  type    = number
}

variable "ecs_cluster_id" {
  type = string
}

variable "memory" {
  default = 512
  type    = number
}

variable "env" {
  default = "bsx"
  type    = string
}

variable "name" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}
