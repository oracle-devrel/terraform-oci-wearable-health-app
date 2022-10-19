## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_identity_smtp_credential" "test_smtp_credential" {
  #Required
  provider = oci.home_region
  description = "SMTP Credentials for ${var.app_name}"
  user_id = var.smtp_user_ocid
}

resource "oci_email_email_domain" "test_email_domain" {
  #Required
  compartment_id = var.compartment_ocid
  name = var.email_domain_name

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  description = "Domain for app ${var.app_name}"

}

resource "oci_email_sender" "test_sender" {
  #Required
  compartment_id = var.compartment_ocid
  email_address  = var.sender_email_address

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

