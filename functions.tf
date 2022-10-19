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
  config = {
    "oci_java_logging_lib_java_util_logging_ConsoleHandler_formatter" = "java.util.logging.SimpleFormatter"
    "oci_java_logging_lib_handlers" = "java.util.logging.ConsoleHandler"
    "oci_java_logging_lib_java_util_logging_SimpleFormatter_format" = "(%4)(%2)%5%6%n"
    "oci_java_logging_lib_java_util_logging_ConsoleHandler_level" = "INFO"
    "ENV_CONTEXT_PATH" = "/admin-api"
    "DATA_SOURCE_URL_OCID" = oci_vault_secret.db_source_env_url.id
    "DATA_SOURCE_USER_OCID" = oci_vault_secret.db_source_env_user.id
    "DATA_SOURCE_PASS_OCID" = oci_vault_secret.db_password.id
    "HMAC_KEY_SECRET_OCID" = oci_vault_secret.hmac_key_secret_jwt.id
  }
}

resource "oci_functions_function" "admin_api_authorizer" {
  depends_on     = [oci_devops_build_pipeline_stage.adminapi_authorizer_deliver_artifact,oci_devops_build_run.adminapi_authorizer_buildrun]
  application_id = oci_functions_application.test_fn_app.id
  display_name   = "${var.app_name}_admin_authorizer"
  image = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_adminapi_authorizer.display_name}:${local.image_tag}"
  memory_in_mbs  = "256"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  config = {
    "HMAC_KEY_SECRET_OCID" = oci_vault_secret.hmac_key_secret_jwt.id
  }
}

locals{
  image_tag = oci_devops_build_run.adminapi_authorizer_buildrun.build_outputs[0].exported_variables[0].items[0].value
}

resource "oci_functions_function" "test_function" {}
