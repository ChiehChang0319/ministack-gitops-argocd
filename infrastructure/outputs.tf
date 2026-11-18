
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_status" {
  value = module.eks.cluster_status
}

output "eks_cluster_role_arn" {
  value = module.iam.eks_cluster_role_arn
}

output "node_group_role_arn" {
  value = module.iam.node_group_role_arn
}

output "node_group_name" {
  value = module.node_group.node_group_name
}

output "node_group_status" {
  value = module.node_group.node_group_status
}