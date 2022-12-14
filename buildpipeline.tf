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

resource "oci_devops_build_pipeline" "webui" {

  #Required
  project_id = oci_devops_project.test_project.id
  depends_on = [oci_objectstorage_bucket.bucket_webui]
  description  = "Build pipeline for webui service"
  display_name = "${var.app_name}_webui_buildpipeline"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  build_pipeline_parameters {
    items {
      name          = "NAMESPACE_NAME"
      default_value = data.oci_objectstorage_namespace.ns.namespace
      description   = "Bucket namespace"
    }
    items {
      name          = "BUCKET_NAME"
      default_value = oci_objectstorage_bucket.bucket_webui.name
      description   = "Bucket name"

    }
    items {
      name = "REGION_NAME"
      default_value = var.region
      description = "OCI Region"
    }
    items {
      name = "REACT_APP_API_GATEWAY_ENDPOINT"
      default_value = oci_apigateway_gateway.api_gateway.hostname
      description = "Gateway endpoint"
    }
    items {
      name = "PUBLIC_URL"
      default_value = "/n/${data.oci_objectstorage_namespace.ns.namespace}/b/${oci_objectstorage_bucket.bucket_webui.name}/o/"
      description = "Bucket information"
    }
    items {
      name = "REACT_APP_WEBSITE_NAME"
      default_value = "OCI Wearable APP Demo"
      description = "Website title"
    }
  }

}

