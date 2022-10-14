## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_objectstorage_bucket" "bucket_dataflow_configs" {
  access_type           = var.bucket_access_type
  auto_tiering          = var.bucket_auto_tiering
  compartment_id        = var.compartment_ocid
  name                  = "${var.app_name}_dataflow_config"
  namespace             = data.oci_objectstorage_namespace.ns.namespace
  object_events_enabled = false
  storage_tier          = var.bucket_storage_tier
  versioning            = var.bucket_versioning
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  timeouts {}
}

resource "oci_objectstorage_bucket" "bucket_dataflow_logs" {
  access_type           = var.bucket_access_type
  auto_tiering          = var.bucket_auto_tiering
  compartment_id        = var.compartment_ocid
  name                  = "${var.app_name}_dataflow_logs"
  namespace             = data.oci_objectstorage_namespace.ns.namespace
  object_events_enabled = false
  storage_tier          = var.bucket_storage_tier
  versioning            = var.bucket_versioning
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  timeouts {}
}

