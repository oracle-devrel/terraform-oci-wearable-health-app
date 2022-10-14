## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_functions_application" "test_fn_app" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}_fn_application"
  subnet_ids     = [oci_core_subnet.application_private_subnet.id]
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_functions_function" "admin_api" {
  depends_on     = [oci_devops_build_pipeline_stage.adminapi_deliver_artifact,oci_devops_build_run.adminapi_buildrun]
  application_id = oci_functions_application.test_fn_app.id
  display_name   = "${var.app_name}_adminapi"
  image = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_adminapi.display_name}:latest"
  memory_in_mbs  = "256"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_functions_function" "admin_api_authorizer" {
  depends_on     = [oci_devops_build_pipeline_stage.adminapi_authorizer_deliver_artifact,oci_devops_build_run.adminapi_authorizer_buildrun]
  application_id = oci_functions_application.test_fn_app.id
  display_name   = "${var.app_name}_admin_authorizer"
  image = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_adminapi_authorizer.display_name}:${local.image_tag}"
  memory_in_mbs  = "256"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

locals{
  image_tag = oci_devops_build_run.adminapi_authorizer_buildrun.build_outputs[0].exported_variables[0].items[0].value
}

