variable "container_definitions_json" {}

variable "container_port" {
  default = 80
}

variable "cpu" {
  default = 256
}

variable "desired_count" {
  default = 1
}

variable "ecs_cluster_id" {}

variable "memory" {
  default = 512
}
variable "env" {
  default = "bsx"
}

variable "name" {
}

variable "sg_name" {}

variable "vpc_id" {}