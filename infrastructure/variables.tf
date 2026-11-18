# terraform 定義變量
# 用 variables 變量傳給 child module 
 
# 區域 region
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_endpoint" {
  description = "Ministack AWS API Endpoint"
  type        = string
  default     = "http://localhost:4566"
}


variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ministack-gitops-argocd"
}


variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet 子網網段
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

# Private Subnet 子網網段
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)

  default = [
    "ap-southeast-1a",
    "ap-southeast-1b"
  ]
}


# EKS 配置
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ministack-eks"
}

# EKS kubernetes version 需要跟ministack 啟動k3s kubernetes版本一致
variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.31"
}

# Node Group 配置
variable "node_group_name" {
  description = "EKS node group name"
  type        = string
  default     = "ministack-workers"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "EC2 instance types"
  type        = list(string)
  default     = ["t3.small"]
}