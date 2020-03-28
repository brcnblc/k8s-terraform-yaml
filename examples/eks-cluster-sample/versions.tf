terraform {
  required_version = ">= 0.12.6"

  required_providers {
    aws      = ">= 2.28.1"
    template = "~> 2.1"
    local    = "~> 1.2"
    null     = "~> 2.1"
    random   = "~> 2.1"
  }
}
