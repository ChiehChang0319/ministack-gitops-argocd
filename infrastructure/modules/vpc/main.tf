# child module 用variables來接收 root module 的值

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # 透過 vpc_id 去Attach VPC main

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs) # count =2 , default=["10.0.1.0/24", "10.0.2.0/24"]

  vpc_id                  = aws_vpc.main.id # 透過 vpc_id 去Attach VPC main
  cidr_block              = var.public_subnet_cidrs[count.index] # count.index=0,1 , default=["10.0.1.0/24", "10.0.2.0/24"]
  availability_zone       = var.availability_zones[count.index] # count.index=0,1 , default=["ap-southeast-1a", "ap-southeast-1b"]
  map_public_ip_on_launch = true # 開啟自動分配公有ip public ip 

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}" # "ministack-gitops-argocd-public-1" , "ministack-gitops-argocd-public-2" 
    Type = "public"

    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs) # count =2 , default=["10.0.11.0/24", "10.0.12.0/24"]

  vpc_id            = aws_vpc.main.id # 透過 vpc_id 去Attach VPC main
  cidr_block        = var.private_subnet_cidrs[count.index] # count.index=0,1 , default=["10.0.11.0/24", "10.0.12.0/24"]
  availability_zone = var.availability_zones[count.index] # count.index=0,1 , default=["ap-southeast-1a", "ap-southeast-1b"]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}" # "ministack-gitops-argocd-private-1" , "ministack-gitops-argocd-private-2" 
    Type = "private"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # 透過 vpc_id 去Attach VPC main

  # 路由 0.0.0.0/0 -> IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt" # "ministack-gitops-argocd-public-rt"
  }
}

# 需要 aws_route_table_association 來關聯 Public subnet 和 Public路由表 
# Public Route Table Association
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public) # count =2

  subnet_id      = aws_subnet.public[count.index].id 
  route_table_id = aws_route_table.public.id
}

# NAT Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id # 分配 Elastic IP 
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.main # 先IGW, 再NAT
  ]

  tags = {
    Name = "${var.project_name}-nat"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # 路由 0.0.0.0/0 -> NAT gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private) # count =2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
