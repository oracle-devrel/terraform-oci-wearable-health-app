## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_build_pipeline" "build_pipeline_notification" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for notification service"
  display_name = "${var.app_name}_notification_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  build_pipeline_parameters {
    items {
      name          = "BASE_CONTAINER_IMAGE"
      default_value = var.buildparam_baseimage_notificationservice
      description   = "base image for container"
    }
  }
}


resource "oci_devops_build_pipeline" "build_pipeline_adminapi_authorizer" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for adminapi authorizer service"
  display_name = "${var.app_name}_adminapi_authorizer_buildpipeline"
}

resource "oci_devops_build_pipeline" "build_pipeline_adminapi" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for adminapi service"
  display_name = "${var.app_name}_adminapi_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_build_pipeline" "build_pipeline_tcpserver" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for tcpserver service"
  display_name = "${var.app_name}_tcpserver_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  build_pipeline_parameters {
    items {
      name          = "BASE_CONTAINER_IMAGE"
      default_value = var.buildparam_baseimage_notificationservice
      description   = "base image for container"
    }
  }
}

resource "oci_devops_build_pipeline" "dataflow" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for tcpserver service"
  display_name = "${var.app_name}_dataflow_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  build_pipeline_parameters {
    items {
      name          = "NAMESPACE_NAME"
      default_value = data.oci_objectstorage_namespace.ns.namespace
      description   = "Bucket namespace"
    }
    items {
      name          = "BUCKET_NAME"
      default_value = oci_objectstorage_bucket.bucket_dataflow_configs.name
      description   = "Bucket name"

  }
}
}

resource "oci_devops_build_pipeline" "db_setup" {

  #Required
  project_id = oci_devops_project.test_project.id

  description  = "Build pipeline for dbsetup service"
  display_name = "${var.app_name}_dbsetup_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

