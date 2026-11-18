#AWS Provider 
provider "aws" {
  region     = var.aws_region

  # 所有 AWS API 全都指向 MiniStack 的 AWS Endpoint 
  endpoints {
    ec2 = var.aws_endpoint
    iam = var.aws_endpoint
    sts = var.aws_endpoint
    eks = var.aws_endpoint
    route53 = var.aws_endpoint
    elbv2 = var.aws_endpoint
  }

  # 本地模擬器AWS模擬, 跳過AWS matadata元數據等驗證
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # 開啟使用路徑式 (Path Style)
  s3_use_path_style = true
}
