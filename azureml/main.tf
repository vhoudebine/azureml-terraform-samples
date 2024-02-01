resource "null_resource" "compute_resouces" {
  provisioner "local-exec" {
    command="az ml compute create --type amlcompute  --location ${var.region} --max-instances ${var.max_cluster_nodes} --min-instances 0 --name ${var.cluster_name} --size ${var.node_type} --idle-time-before-scale-down 600  --resource-group ${var.resource_group} --workspace-name ${var.workspace_name}"
  }

}