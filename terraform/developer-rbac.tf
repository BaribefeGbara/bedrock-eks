# Map IAM user to Kubernetes RBAC
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = aws_iam_user.developer.arn
        username = "bedrock-dev-view"
        groups   = ["view-only"]
      }
    ])
  }

  force = true
}

# Create ClusterRoleBinding for view-only access
resource "kubernetes_cluster_role_binding" "view_only" {
  metadata {
    name = "view-only-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "Group"
    name      = "view-only"
    api_group = "rbac.authorization.k8s.io"
  }
}
