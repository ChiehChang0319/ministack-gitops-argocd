
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn # 指定 EKS Cluster 使用的 IAM Role

  version = var.kubernetes_version # 指定 EKS 的 kubernetes 版本

  # EKS Cluster 的 VPC Network 環境
  vpc_config {
    subnet_ids = var.subnet_ids # 指定EKS cluster 的 subnet

    endpoint_private_access = true # 開放 Private API Endpoint
    endpoint_public_access  = true # 開放 Public API Endpoint
  }

  tags = {
    Name = var.cluster_name
    Environment = "local"
    ManagedBy   = "Terraform"
  }
}