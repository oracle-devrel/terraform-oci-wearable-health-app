## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# oci_devops_build_pipeline_stage.dbsetup_build_pipeline_stage:
resource "oci_devops_build_pipeline_stage" "dbsetup_build_pipeline_stage" {
  build_pipeline_id                  = oci_devops_build_pipeline.db_setup.id
  build_pipeline_stage_type          = var.build_pipeline_stage_build_pipeline_stage_type
  build_spec_file                    = var.dbsetup_buildspec
  defined_tags                       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  freeform_tags                      = {}
  display_name                       = "DB Setup"
  image                              = var.build_pipeline_stage_image
  stage_execution_timeout_in_seconds = var.build_pipeline_stage_stage_execution_timeout_in_seconds

  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline.db_setup.id
    }
  }

  build_source_collection {
    items {
      branch          = var.build_pipeline_stage_build_source_collection_items_branch
      connection_type = var.build_pipeline_stage_build_source_collection_items_connection_type
      name            = var.build_pipeline_stage_build_source_collection_items_name
      repository_id   = oci_devops_repository.test_repository.id
      repository_url  = "https://devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name}"
    }
  }

  private_access_config {
    network_channel_type = "SERVICE_VNIC_CHANNEL"
    nsg_ids              = []
    subnet_id            = oci_core_subnet.application_private_subnet.id
  }

  timeouts {}
}
