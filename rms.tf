## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// The RMS private endpoint resource. Requires a VCN with a private subnet
resource "oci_resourcemanager_private_endpoint" "rms_pe_mysql" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}_privateendpoint_formysql"
  description    = "Private Endpoint to remote-exec in Private MySQL DB"
  vcn_id         = oci_core_virtual_network.vcn.id
  subnet_id      = oci_core_subnet.application_private_subnet.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}