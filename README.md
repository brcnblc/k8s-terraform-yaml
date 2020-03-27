# Terraform Module to Deploy Kubernetes Yaml Files #

  This module makes Terraform possible to use YAML files as a source for every operation that is provided by official Kubernetes provider.

### Example Usage ###
```terraform
provider "kubernetes" {

}

locals {
  appConfig = merge (
    {
        test-app = {
          k8s = {
            deployment = yamldecode(file("deployment.yml"))
            service = yamldecode(file("service.yml"))
          }
        } 
    }
  )
}

module "k8s_yaml_tf" {
  source = "../k8s-yaml-tf" 

  appConfig = local.appConfig
  module_enabled=true
}
```


