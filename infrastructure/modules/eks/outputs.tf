# 創建EKS完成後結果 output 回傳給其他 module

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

# 輸出 Kubernetes Cluster 的 CA Certificate，可以用於 Kubernetes API Server 的 TLS 驗證
output "cluster_certificate_authority" {
  value = try(
    aws_eks_cluster.main.certificate_authority[0].data,
    null
  )
}

output "cluster_status" {
  value = aws_eks_cluster.main.status
}