variable "name" {
  type    = string
  default = "ministack-eks-alb"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "nginx_port" {
  type    = number
  default = 8081
}

variable "envoy_port" {
  type    = number
  default = 8082
}