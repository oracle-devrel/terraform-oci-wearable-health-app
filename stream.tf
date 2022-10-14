## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_streaming_stream" "test_stream" {
  compartment_id     = var.compartment_ocid
  defined_tags       ={ "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  name               = "${var.app_name}_stream"
  partitions         = var.stream_partition_count
  retention_in_hours = var.stream_retention_in_hours

  timeouts {}
}
