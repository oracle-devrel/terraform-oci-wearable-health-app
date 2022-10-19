## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#  Artifact Repository

resource "oci_artifacts_repository" "test_repository" {
  #Required
  compartment_id  = var.compartment_ocid
  is_immutable    = false
  display_name = "${var.app_name}_notification_service"
  repository_type = "GENERIC"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

## Upload artifact to repo
#
#resource "oci_generic_artifacts_content_artifact_by_path" "upload_sql_artifact" {
#  depends_on = [oci_artifacts_repository.test_repository,null_resource.update_placeholders,null_resource.pushcode]
#  #Required
#  artifact_path  = var.artifact_name
#  repository_id    = oci_artifacts_repository.test_repository.id
#  version = var.artifact_version
#  source = "${path.module}/${var.git_repo_name}/DB-Setup/setup.sql"
#}

# Container repos

resource "oci_artifacts_container_repository" "container_repository_notification" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${lower(var.app_name)}_notification_repo_${random_id.tag.hex}"
  #Optional
  is_public = var.container_repository_is_public

}

resource "oci_artifacts_container_repository" "container_repository_adminapi" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${lower(var.app_name)}_adminapi_repo_${random_id.tag.hex}"
  #Optional
  is_public = var.container_repository_is_public

}

resource "oci_artifacts_container_repository" "container_repository_adminapi_authorizer" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${lower(var.app_name)}_adminapi_authorizer_${random_id.tag.hex}"
  #Optional
  is_public = var.container_repository_is_public

}

resource "oci_artifacts_container_repository" "container_repository_tcpserver" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "${lower(var.app_name)}_tcpserver_repo_${random_id.tag.hex}"
  #Optional
  is_public = var.container_repository_is_public

}

# Devops artifacts

resource "oci_devops_deploy_artifact" "notification_service_manifest" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  deploy_artifact_type       = "KUBERNETES_MANIFEST"
  display_name               =  "notification-service-manifest"
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_path        = "notification-service-manifest"
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version     = "$${BUILDRUN_HASH}"
    repository_id               = oci_artifacts_repository.test_repository.id
  }

  timeouts {}
}

resource "oci_devops_deploy_artifact" "notification_service_image" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = "OCIR"

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_notification.display_name}:$${BUILDRUN_HASH}"
    image_digest  = " "

  }

  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "notification-service-image"
}

resource "oci_devops_deploy_artifact" "adminapi_service_image" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = "OCIR"

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_adminapi.display_name}:latest"
    image_digest  = " "

  }

  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "admin-api-image"
}

resource "oci_devops_deploy_artifact" "adminapi_authorizer_service_image" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = "OCIR"

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_adminapi_authorizer.display_name}:$${BUILDRUN_HASH}"
    image_digest  = " "

  }

  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "admin-api-authorizer-image"
}

resource "oci_devops_deploy_artifact" "tcpserver_service_manifest" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  deploy_artifact_type       = "KUBERNETES_MANIFEST"
  display_name               =  "tcp-server-manifest"
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_path        = "tcp-server-manifest"
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version     = "$${BUILDRUN_HASH}"
    repository_id               = oci_artifacts_repository.test_repository.id
  }

  timeouts {}
}

resource "oci_devops_deploy_artifact" "tcpserver_service_image" {

  #Required
  argument_substitution_mode = var.deploy_artifact_argument_substitution_mode
  deploy_artifact_source {
    #Required
    deploy_artifact_source_type = "OCIR"

    #Optional
    image_uri     = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_tcpserver.display_name}:$${BUILDRUN_HASH}"
    image_digest  = " "

  }

  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.test_project.id

  #Optional
  display_name = "tcp-server-image"
}