# 使用 data "aws_iam_policy_document" 生成 JSON 策略 
# EKS Cluster Trust Policy
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# 用 resource "aws_iam_role" 來將產生 JSON Policy (Trust Policy) 設置到 Role 
# EKS Cluster Role
resource "aws_iam_role" "eks_cluster" {
  name               = "${var.project_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

# 透過 resource "aws_iam_role_policy_attachment" 將 Policy (Permission Policy) 附加到 Role
# Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# 使用 data "aws_iam_policy_document" 生成 JSON 策略 
# Node Group Trust Policy
data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# 用 resource "aws_iam_role" 來將產生 JSON Policy (Trust Policy) 設置到 Role 
# Node Group Role
resource "aws_iam_role" "node_group" {
  name               = "${var.project_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
}

# 透過 resource "aws_iam_role_policy_attachment" 將 Policy (Permission Policy) 附加到 Role
# Worker Node Policy
resource "aws_iam_role_policy_attachment" "worker_node" {
  role = aws_iam_role.node_group.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# 透過 resource "aws_iam_role_policy_attachment" 將 Policy (Permission Policy) 附加到 Role
# CNI Policy
resource "aws_iam_role_policy_attachment" "cni" {
  role = aws_iam_role.node_group.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# 透過 resource "aws_iam_role_policy_attachment" 將 Policy (Permission Policy) 附加到 Role
# ECR Read Only Policy
resource "aws_iam_role_policy_attachment" "ecr" {
  role = aws_iam_role.node_group.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}