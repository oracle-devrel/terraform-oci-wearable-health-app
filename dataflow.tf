## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
resource "oci_dataflow_application" "core_application" {
  depends_on = [oci_mysql_mysql_db_system.mysql_db,oci_identity_policy.policy]
  arguments          = [local.optional_arg_1]
  class_name         = var.dataflow_mainclass
  compartment_id     = var.compartment_ocid
  configuration      = {
    "dataflow.auth"                                   = var.dataflow_authmode
    "spark.dataflow.dynamicAllocation.quotaPolicy"    = "min"
    "spark.dynamicAllocation.enabled"                 = "true"
    "spark.dynamicAllocation.executorIdleTimeout"     = "60"
    "spark.dynamicAllocation.maxExecutors"            = var.dataflow_maxExecutors
    "spark.dynamicAllocation.minExecutors"            = var.dataflow_minExecutors
    "spark.dynamicAllocation.schedulerBacklogTimeout" = "60"
    "spark.dynamicAllocation.shuffleTracking.enabled" = "true"
  }
  description        = "Data flow for ${var.app_name}"
  display_name       = "${var.app_name}_dataflow"
  driver_shape       = var.dataflow_driver_shape
  executor_shape     = var.dataflow_executor_shape
  file_uri           = "oci://${oci_objectstorage_bucket.bucket_dataflow_configs.name}@${data.oci_objectstorage_namespace.ns.namespace}/healtheventanalysis.jar"
  language           = "JAVA"
  logs_bucket_uri    = "oci://${oci_objectstorage_bucket.bucket_dataflow_logs.name}@${data.oci_objectstorage_namespace.ns.namespace}/"
  num_executors      = var.dataflow_num_executors
  spark_version      = var.dataflow_spark_version
  type               = var.dataflow_type

  application_log_config {
    log_group_id = oci_logging_log_group.test_log_group.id
    log_id       = oci_logging_log.dataflow_log.id
  }

  driver_shape_config {
    memory_in_gbs = var.dataflow_driver_shape_config_memory_in_gbs
    ocpus         = var.dataflow_driver_shape_config_ocpus
  }

  executor_shape_config {
    memory_in_gbs = var.dataflow_executor_shape_config_memory_in_gbs
    ocpus         = var.dataflow_executor_shape_config_ocpus
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  timeouts {}
}

locals {
  optional_arg_1 = "oci://${oci_objectstorage_bucket.bucket_dataflow_configs.name}@${data.oci_objectstorage_namespace.ns.namespace}/health_data.json oci://${oci_objectstorage_bucket.bucket_dataflow_configs.name}@${data.oci_objectstorage_namespace.ns.namespace}/data_schema.json root IoT_health_app@2022 ${oci_mysql_mysql_db_system.mysql_db.ip_address} health_app"
}