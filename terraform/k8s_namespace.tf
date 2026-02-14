resource "kubernetes_namespace" "retail_app" {
  metadata {
    name = "retail-app"
  }
}
