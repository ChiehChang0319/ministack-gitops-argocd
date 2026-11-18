
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name  # Node Group 要加入哪個 EKS Cluster
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids # 指定 Worker Nodes 要部署在哪些 Subnets

  instance_types = var.instance_types # 指定 Worker Nodes 使用的 EC2 規格

  # 負責控制 Node Group 的節點數量
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  # 設定的是 Kubernetes Node Labels
  labels = {
    role        = "worker"
    environment = "local"
  }

  tags = {
    Name      = var.node_group_name
    ManagedBy = "Terraform"
  }
}