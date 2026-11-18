# 創建VPC完成後結果 output 回傳給其他 module

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "all_subnet_ids" {
  value = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id
  )
}