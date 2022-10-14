## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# OKE Envs
resource "oci_devops_deploy_environment" "oke_environment" {
  display_name            = "${var.app_name}_oke_env"
  description             = "oke based enviroment"
  deploy_environment_type = "OKE_CLUSTER"
  project_id              = oci_devops_project.test_project.id
  cluster_id              = var.create_new_oke_cluster ? module.oci-oke[0].cluster.id : var.existent_oke_cluster_id
  defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#Function Envs

resource "oci_devops_deploy_environment" "function_environment_adminapi" {
  depends_on = [oci_functions_function.admin_api]
  display_name            = "${var.app_name}_fn_adminapi_env"
  description             = "function based environment for adminapi"
  deploy_environment_type = "FUNCTION"
  project_id              = oci_devops_project.test_project.id
  function_id             = oci_functions_function.admin_api.id
  defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_environment" "function_environment_adminapi_authorizer" {
  depends_on = [oci_functions_function.admin_api_authorizer]
  display_name            = "${var.app_name}_fn_adminapi_auth_env"
  description             = "function based environment for adminapi authorizer"
  deploy_environment_type = "FUNCTION"
  project_id              = oci_devops_project.test_project.id
  function_id             = oci_functions_function.admin_api_authorizer.id
  defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}