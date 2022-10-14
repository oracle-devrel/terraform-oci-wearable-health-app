## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "tcpserver_oke_deploy" {
  defined_tags                            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  deploy_pipeline_id                      = oci_devops_deploy_pipeline.deploy_pipeline_tcpserver.id
  deploy_stage_type                       = "OKE_DEPLOYMENT"
  description                             = "Deploy to OKE"
  display_name                            = "Deploy to OKE - TCP Server Service"
  freeform_tags                           = {}
  kubernetes_manifest_deploy_artifact_ids = [
    oci_devops_deploy_artifact.tcpserver_service_manifest.id
  ]
  namespace                               = var.oke_namespace
  oke_cluster_deploy_environment_id       = oci_devops_deploy_environment.oke_environment.id


  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.deploy_pipeline_tcpserver.id
    }
  }

  rollback_policy {
    policy_type = var.oke_deploy_rollback_policy
  }

  timeouts {}
}