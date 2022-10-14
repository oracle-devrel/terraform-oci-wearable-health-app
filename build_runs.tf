## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_run" "notification_buildrun" {

  depends_on = [oci_devops_build_pipeline_stage.notification_deliver_artifact,
    oci_devops_build_pipeline.build_pipeline_notification,
    oci_devops_build_pipeline_stage.notification_build_pipeline_stage,
    oci_devops_deploy_artifact.notification_service_manifest,
    oci_devops_deploy_stage.notification_oke_deploy,
    oci_devops_build_pipeline_stage.notificaton_invoke_deployment,
    oci_devops_deploy_artifact.notification_service_image,
    oci_identity_policy.policy,
    oci_core_instance.compute_instance
  ]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_notification.id

  #Optional
  display_name = "notification_build_run_${random_id.tag.hex}"
  provisioner "local-exec" {
    command = "sleep 300"
  }
}

resource "oci_devops_build_run" "adminapi_buildrun" {

  depends_on = [oci_functions_application.test_fn_app,
    oci_devops_build_pipeline.build_pipeline_adminapi,
    oci_devops_deploy_pipeline.deploy_pipeline_adminapi,
    oci_devops_build_pipeline_stage.adminapi_deliver_artifact,
    oci_devops_build_pipeline_stage.adminapi_invoke_deployment,
    oci_identity_policy.policy,
    oci_core_instance.compute_instance
  ]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_adminapi.id

  #Optional
  display_name = "adminapi_build_run_${random_id.tag.hex}"
  provisioner "local-exec" {
    command = "sleep 300"
  }
}

resource "oci_devops_build_run" "adminapi_authorizer_buildrun" {

  depends_on = [oci_functions_application.test_fn_app,
    oci_artifacts_container_repository.container_repository_adminapi_authorizer,
    oci_devops_build_pipeline.build_pipeline_adminapi_authorizer,
    oci_devops_build_pipeline_stage.adminapi_authorizer_build_pipeline_stage,
    oci_devops_build_pipeline_stage.adminapi_authorizer_deliver_artifact,
    oci_devops_deploy_pipeline.deploy_pipeline_adminapi_authorizer,
    oci_devops_build_pipeline_stage.adminapi_authorizer_invoke_deployment,
    oci_identity_policy.policy,oci_core_instance.compute_instance,
    oci_identity_policy.policy
  ]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_adminapi_authorizer.id

  #Optional
  display_name = "adminapi_authorizer_build_run_${random_id.tag.hex}"
  provisioner "local-exec" {
    command = "sleep 300"
  }
}

resource "oci_devops_build_run" "tcpserver_buildrun" {

  depends_on = [oci_devops_build_pipeline_stage.tcpserver_invoke_deployment,
    oci_devops_deploy_stage.tcpserver_oke_deploy,
    oci_devops_build_pipeline.build_pipeline_tcpserver,
    oci_devops_build_pipeline_stage.tcpserver_build_pipeline_stage,
    oci_devops_build_pipeline_stage.tcpserver_deliver_artifact,
    oci_devops_deploy_artifact.tcpserver_service_manifest,
    oci_devops_build_pipeline_stage.tcpserver_invoke_deployment,
    oci_core_instance.compute_instance,
    oci_identity_policy.policy
  ]

  #Required
  build_pipeline_id = oci_devops_build_pipeline.build_pipeline_tcpserver.id

  #Optional
  display_name = "tcpserver_build_run_${random_id.tag.hex}"
  provisioner "local-exec" {
    command = "sleep 300"
  }
}