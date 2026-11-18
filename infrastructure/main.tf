
# Module 1: VPC
module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
}


# Module 2: IAM
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}


# Module 3: EKS Cluster
module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name

  kubernetes_version = var.kubernetes_version

  cluster_role_arn = module.iam.eks_cluster_role_arn

  subnet_ids = module.vpc.all_subnet_ids

  depends_on = [
    module.vpc,
    module.iam
  ]
}


# Module 4: EKS Node Group
module "node_group" {
  source = "./modules/node-group"

  cluster_name    = module.eks.cluster_name
  node_group_name = var.node_group_name

  node_role_arn = module.iam.node_group_role_arn

  subnet_ids = module.vpc.private_subnet_ids

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  instance_types = var.instance_types

  depends_on = [
    module.eks,
    module.iam
  ]
}


# Module 5: Load Balancer
module "load_balancer" {
  source = "./modules/load-balancer"

  name = "ministack-eks-alb"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

}


# Module 6: Route 53
module "route53" {
  source = "./modules/route53"

  domain_name = "local.test"

  alb_dns_name = module.load_balancer.alb_dns_name
  alb_zone_id  = module.load_balancer.alb_zone_id

}