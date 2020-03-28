variable "region" {
  description = "Cloud Provider region name."
  default = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS Profile for credentials"
  default     = "default"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "vpc" {
  description = "VPC Definitions"
  type        = any
  default     = {
    cidr                 = "172.16.0.0/16",
    private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
    public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
    enable_nat_gateway   = true
    single_nat_gateway   = true
    enable_dns_hostnames = true
  }
}

variable "cluster" {
  description = "Cluster Definitions"
  type        = any
  default     = {
    enabled              = true
    name_prefix         = "test-cluster"
    tags                = {}
    update_kube_config  = true
    node_group = {
      defaults = {
        ami_type          = "AL2_x86_64"
        disk_size         = 20
      }
      members = {
        ng1 = {
          desired_capacity = 1
          max_capacity     = 3
          min_capacity     = 1
          instance_type    = "t3.small"
          k8s_labels = {
            Environment    = "test"
            GithubRepo     = "terraform-aws-eks"
          }
          additional_tags = {
            role          = "worker"
          }
        }
      }
    }
    deployments = {
      metrics_server = {
        enabled = true
      }
      kubernetes_dashboard = {
        enabled = true
        csrf = "myDashboardCsrf99"
      }
    }
  }
}