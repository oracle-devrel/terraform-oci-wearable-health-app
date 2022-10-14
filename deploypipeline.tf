## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_pipeline" "deploy_pipeline_notification" {
  #Required
  project_id   = oci_devops_project.test_project.id
  description  = "Deploy pipeline for notification service"
  display_name = "${var.app_name}_notification_deploypipeline"

  deploy_pipeline_parameters {
    items {
      name          = "EMAIL_FROM_ADDRESS"
      default_value = var.sender_email_address
      description   = "SMTP From address"
    }
    items {
      name          = "EMAIL_HOST"
      default_value = "smtp.email.${var.region}.oci.oraclecloud.com"
      description   = "SMTP host address"
    }

    items {
      name          = "SMTP_PASSWORD_OCID"
      default_value = oci_vault_secret.smtp_password.id
      description   = "OCID of SMTP Password secret"
    }

    items {
      name          = "SMTP_USERNAME"
      default_value = var.smtp_user_ocid
      description   = "OCID of SMTP User"
    }
    items {
      name          = "AUTH_PROFILE"
      default_value = var.auth_profile
      description   = "Auth profile"
    }
    items {
      name          = "QUEUE_REGION_ID"
      default_value = var.region
      description   = "OCI Queue region"
    }
    items {
      name          = "QUEUE_OCID"
      default_value = var.oci_queue_ocid
      description   = "OCI Queue OCID"
    }
    items {
      name          = "DB_HOST"
      default_value = oci_mysql_mysql_db_system.mysql_db.ip_address
      description   = "MySQL DB Host"
    }
    items {
      name          = "DB_NAME"
      default_value = "health_app"
      description   = "MySQL DB Table"
    }



  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_pipeline" "deploy_pipeline_adminapi" {
   project_id   = oci_devops_project.test_project.id
  description  = "Deploy pipeline for adminapi service"
  display_name = "${var.app_name}_adminapi_deploypipeline"

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_pipeline" "deploy_pipeline_adminapi_authorizer" {
  project_id   = oci_devops_project.test_project.id
  description  = "Deploy pipeline for adminapi authorizer service"
  display_name = "${var.app_name}_adminapi_authorizer_deploypipeline"

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_pipeline" "deploy_pipeline_tcpserver" {
  project_id   = oci_devops_project.test_project.id
  description  = "Deploy pipeline for tcpserver service"
  display_name = "${var.app_name}_tcpserver_deploypipeline"
  deploy_pipeline_parameters {
    items {
      name          = "TCP_SERVER_PORT"
      default_value = "9876"
      description   = "TCP Port number"
    }
    items {
      name          = "DB_NAME"
      default_value = "health_app"
      description   = "DB name"
    }
    items {
      name          = "AUTH_PROFILE"
      default_value = var.auth_profile
      description   = "Auth profile"
    }
    items {
      name          = "STREAM_OCID"
      default_value = oci_streaming_stream.test_stream.id
      description   = "Stream OCID"
    }
    items {
      name          = "DB_HOST"
      default_value = oci_mysql_mysql_db_system.mysql_db.ip_address
      description   = "MySQL DB Host"
    }
    items {
      name          = "STREAM_MESSAGING_ENDPOINT"
      default_value = oci_streaming_stream.test_stream.messages_endpoint
      description   = "Stream endpoint"
    }
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}