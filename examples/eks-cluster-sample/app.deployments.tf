module "metrics_server" {
  source = "./modules/metrics-server"
  module_depends_on = [module.eks]
  enabled = var.cluster.deployments.metrics_server.enabled
}

module "kubernetes_dashboard" {
  source = "./modules/kubernetes-dashboard"
  module_depends_on = [module.eks]
  kubernetes_dashboard_csrf = var.cluster.deployments.kubernetes_dashboard.csrf
  enabled = var.cluster.deployments.kubernetes_dashboard.enabled
}

module "k8s_yaml_tf" {
  source = "github.com/brcnblc/k8s-terraform-yaml" 
  module_depends_on = [module.eks]
  appConfig = var.appConfig
}

