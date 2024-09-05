resource "null_resource" "compute_resouces" {
  provisioner "local-exec" {
    command="bash segmentation-deploy.sh ${var.subscription_id} ${var.resource_group} ${var.workspace_name}"
  }

}