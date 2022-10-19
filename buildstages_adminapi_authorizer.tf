## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_pipeline_stage" "adminapi_authorizer_build_pipeline_stage" {
  depends_on = [null_resource.pushcode]
  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_adminapi_authorizer.id
  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline.build_pipeline_adminapi_authorizer.id
    }
  }
  build_pipeline_stage_type = var.build_pipeline_stage_build_pipeline_stage_type

  #Optional
  build_source_collection {

    #Optional
    items {
      #Required
      connection_type = var.build_pipeline_stage_build_source_collection_items_connection_type

      #Optional
      branch = var.build_pipeline_stage_build_source_collection_items_branch
      name           = var.build_pipeline_stage_build_source_collection_items_name
      repository_id  = oci_devops_repository.test_repository.id
      repository_url = "https://devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name}"
    }
  }

  build_spec_file = var.adminapi_authorizer_buildspec

  display_name                       = var.build_pipeline_stage_display_name
  image                              = var.build_pipeline_stage_image
  stage_execution_timeout_in_seconds = var.build_pipeline_stage_stage_execution_timeout_in_seconds
  wait_criteria {
    #Required
    wait_duration = var.build_pipeline_stage_wait_criteria_wait_duration
    wait_type     = var.build_pipeline_stage_wait_criteria_wait_type
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

# Deliver artifact stage
resource "oci_devops_build_pipeline_stage" "adminapi_authorizer_deliver_artifact" {

  depends_on = [oci_devops_build_pipeline_stage.adminapi_authorizer_build_pipeline_stage]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_adminapi_authorizer.id
  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.adminapi_authorizer_build_pipeline_stage.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deliver_artifact_stage_type

  deliver_artifact_collection {

    #Optional
    items {
      artifact_id   = oci_devops_deploy_artifact.adminapi_authorizer_service_image.id
      artifact_name = "admin_api_authorizer_function_image"
    }

  }
  display_name = var.deliver_artifact_stage_display_name
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

#Invoke deployment pipeline

resource "oci_devops_build_pipeline_stage" "adminapi_authorizer_invoke_deployment" {

  depends_on = [oci_devops_build_pipeline_stage.adminapi_authorizer_deliver_artifact]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_adminapi_authorizer.id

  build_pipeline_stage_predecessor_collection {
    #Required
    items {
      #Required
      id = oci_devops_build_pipeline_stage.adminapi_authorizer_deliver_artifact.id
    }
  }

  build_pipeline_stage_type = var.build_pipeline_stage_deploy_stage_type

  deploy_pipeline_id             = oci_devops_deploy_pipeline.deploy_pipeline_adminapi_authorizer.id
  display_name                   = var.deploy_stage_display_name
  is_pass_all_parameters_enabled = var.build_pipeline_stage_is_pass_all_parameters_enabled
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}