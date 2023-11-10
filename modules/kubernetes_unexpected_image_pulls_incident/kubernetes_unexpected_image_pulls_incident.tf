resource "shoreline_notebook" "kubernetes_unexpected_image_pulls_incident" {
  name       = "kubernetes_unexpected_image_pulls_incident"
  data       = file("${path.module}/data/kubernetes_unexpected_image_pulls_incident.json")
  depends_on = [shoreline_action.invoke_remove_deployment_and_image]
}

resource "shoreline_file" "remove_deployment_and_image" {
  name             = "remove_deployment_and_image"
  input_file       = "${path.module}/data/remove_deployment_and_image.sh"
  md5              = filemd5("${path.module}/data/remove_deployment_and_image.sh")
  description      = "Remove the compromised container images ."
  destination_path = "/tmp/remove_deployment_and_image.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_remove_deployment_and_image" {
  name        = "invoke_remove_deployment_and_image"
  description = "Remove the compromised container images ."
  command     = "`chmod +x /tmp/remove_deployment_and_image.sh && /tmp/remove_deployment_and_image.sh`"
  params      = ["NAMESPACE","DEPLOYMENT"]
  file_deps   = ["remove_deployment_and_image"]
  enabled     = true
  depends_on  = [shoreline_file.remove_deployment_and_image]
}

