
variable "cluster_name" {
  type = string
}

# EKS kubernetes version 需要跟ministack 啟動k3s kubernetes版本一致
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

# 接收 EKS Cluster 使用的 IAM Role
variable "cluster_role_arn" {
  type = string
}

# 接收 EKS Cluster 使用的 Subnet
variable "subnet_ids" {
  type = list(string)
}
