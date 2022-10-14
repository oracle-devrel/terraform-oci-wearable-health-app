
## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# Create log and log group

# Create devops project

resource "oci_devops_project" "test_project" {
  compartment_id = var.compartment_ocid
  name           = "${var.app_name}_devopsproject_${random_string.deploy_id.result}"

  notification_config {
    #Required
    topic_id = oci_ons_notification_topic.test_notification_topic.id
  }

  #Optional
  description  = var.project_description
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
