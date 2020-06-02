resource "kubernetes_horizontal_pod_autoscaler" "instance" { 
  depends_on = [null_resource.module_depends_on]
  for_each = local.horizontal_pod_autoscaler.applications

  dynamic "metadata" { # Nesting Mode: list  Min Items : 1  Max Items : 1  
    for_each = contains(keys(each.value), "metadata") ? {item = each.value["metadata"]} : {}

    content {
      annotations = lookup(metadata.value, "annotations", null)
      # Type: ['map', 'string']   Optional  
      # An unstructured key value map stored with the horizontal pod autoscaler that may be used to store arbitrary metadata. More info: http://kubernetes.io/docs/user-guide/annotations

      generate_name = lookup(metadata.value, "generateName", null)
      # Type: string   Optional  
      # Prefix, used by the server, to generate a unique name ONLY IF the `name` field has not been provided. This value will also be combined with a unique suffix. Read more: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#idempotency

      labels = lookup(metadata.value, "labels", null)
      # Type: ['map', 'string']   Optional  
      # Map of string keys and values that can be used to organize and categorize (scope and select) the horizontal pod autoscaler. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels

      name = lookup(metadata.value, "name", null)
      # Type: string   Optional Computed 
      # Name of the horizontal pod autoscaler, must be unique. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names

      namespace = var.namespace != "" ? var.namespace : lookup(metadata.value, "namespace", null)
      # Type: string   Optional  
      # Namespace defines the space within which name of the horizontal pod autoscaler must be unique.

    }
  }

  dynamic "spec" { # Nesting Mode: list  Min Items : 1  Max Items : 1  
    for_each = contains(keys(each.value), "spec") ? {item = each.value["spec"]} : {}

    content {
      max_replicas = lookup(spec.value, "maxReplicas", null)
      # Type: number Required    
      # Upper limit for the number of pods that can be set by the autoscaler.

      min_replicas = lookup(spec.value, "minReplicas", null)
      # Type: number   Optional  
      # Lower limit for the number of pods that can be set by the autoscaler, defaults to `1`.

      target_cpu_utilization_percentage = lookup(spec.value, "targetCpuUtilizationPercentage", null)
      # Type: number   Optional Computed 
      # Target average CPU utilization (represented as a percentage of requested CPU) over all the pods. If not specified the default autoscaling policy will be used.

      dynamic "scale_target_ref" { # Nesting Mode: list  Min Items : 1  Max Items : 1  
        for_each = contains(keys(spec.value), "scaleTargetRef") ? {item = spec.value["scaleTargetRef"]} : {}

        content {
          api_version = lookup(scale_target_ref.value, "apiVersion", null)
          # Type: string   Optional  
          # API version of the referent

          kind = lookup(scale_target_ref.value, "kind", null)
          # Type: string Required    
          # Kind of the referent. e.g. `ReplicationController`. More info: http://releases.k8s.io/HEAD/docs/devel/api-conventions.md#types-kinds

          name = lookup(scale_target_ref.value, "name", null)
          # Type: string Required    
          # Name of the referent. More info: http://kubernetes.io/docs/user-guide/identifiers#names

        }
      }

    }
  }


}