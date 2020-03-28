
provider "aws" {
   region  = var.region
   profile = var.aws_profile
}

data "aws_eks_cluster" "cluster" {
  count = var.cluster.enabled ? 1 : 0
  name  = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.cluster.enabled ? 1 : 0
  name  = module.eks.cluster_id
}

# In case of not creating the cluster, this will be an incompletely configured, unused provider, which poses no problem.
provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
}

data "aws_availability_zones" "available" {
}

locals {
  cluster_name = "${var.cluster.name_prefix}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.6"

  name                 = local.cluster_name
  cidr                 = var.vpc.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.vpc.private_subnets
  public_subnets       = var.vpc.public_subnets
  enable_nat_gateway   = var.vpc.enable_nat_gateway
  single_nat_gateway   = var.vpc.single_nat_gateway
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  create_eks   = var.cluster.enabled
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets
  tags = var.cluster.tags
  vpc_id = module.vpc.vpc_id
  node_groups_defaults = var.cluster.node_group.defaults
  node_groups = var.cluster.node_group.members
  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}

resource "null_resource" "update_kube_config" {
  count = var.cluster.enabled && var.cluster.update_kube_config ? 1 : 0
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --profile ${var.aws_profile} --name ${local.cluster_name}"
  }
}
