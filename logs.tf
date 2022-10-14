## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# Create log and log group

resource "oci_logging_log_group" "test_log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}_loggroup_${random_string.deploy_id.result}"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_logging_log" "test_log" {
  #Required
  display_name = "${var.app_name}_devops_log_group_log"
  log_group_id = oci_logging_log_group.test_log_group.id
  log_type     = "SERVICE"

  #Optional
  configuration {
    #Required
    source {
      #Required
      category    = "all"
      resource    = oci_devops_project.test_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }

    #Optional
    compartment_id = var.compartment_ocid
  }

  is_enabled         = true
  retention_duration = var.project_logging_config_retention_period_in_days
  defined_tags       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_logging_log" "test_log1" {
  defined_tags       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  display_name       = "${var.app_name}_fnInvokeLogs"
  freeform_tags      = {}
  log_group_id       = oci_logging_log_group.test_log_group.id
  log_type           = "SERVICE"
  retention_duration = var.project_logging_config_retention_period_in_days

  configuration {
    compartment_id = var.compartment_ocid

    source {
      category    = "invoke"
      resource    = oci_functions_application.test_fn_app.id
      service     = "functions"
      source_type = "OCISERVICE"
    }
  }
  timeouts {}
}
