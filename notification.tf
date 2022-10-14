## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create OCI Notification

resource "oci_ons_notification_topic" "test_notification_topic" {
  compartment_id = var.compartment_ocid
  name           = "${var.app_name}_topic_${random_string.deploy_id.result}"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
