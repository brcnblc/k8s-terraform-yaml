variable "appConfig" {
  description = "Deployment Configurations"
  type = any
  default = {}
}

variable "namespace" {
  description = "Namespace to apply"
  type = string
  default = ""
}