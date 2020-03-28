provider "kubernetes" {

}

locals {
  files= fileset("/deployment", "**")
  
}

module "k8s_yaml_tf" {
  source = "github.com/brcnblc/k8s-terraform-yaml" 
  appConfig = local.appConfig
}
