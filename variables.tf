### Copyright (c) 2022, Oracle and/or its affiliates.
### All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "app_name" {
  default     = "cwiotapp"
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}

variable "oci_user_name" {}
variable "oci_user_authtoken" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.1"
}


/*API Gateway Variables **********/

variable "gateway_displayname" {
  default = "apigateway"
}

variable "gateway_visibility" {
  default = "PUBLIC"
}

variable "path_prefix" {
  default = "/admin-api"
}

/********** API Gateway Variables **********/

/********** VCN Variables **********/
variable "VCN-CIDR" {
  default = "10.100.0.0/16"
}

variable "Public-Subnet-CIDR" {
  default = "10.100.0.0/24"
}


variable "Private-Subnet-CIDR" {
  default = "10.100.10.0/24"
}

variable "application_network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                      = "10.100.0.0/16"
    PRIVATE-SUBNET-CIDR           = "10.100.10.0/24"
    PUBLIC-SUBNET-CIDR            = "10.100.0.0/24"
    ALL-CIDR                      = "0.0.0.0/0"

  }
}


/********** VCN Variables **********/


/********** MySQL Variables **********/

variable "availability_domain_name" {
  default = ""
}

variable "mysql_instance_compartment_name" {
  description = "Compartment where MySQL Instance will be created"
  default = ""
}

variable "mysql_network_compartment_name" {
  description = "Compartment where the network of MySQL artifact is"
  default = ""
}

variable "mysql_instance_compartment_ocid" {
  description = "OCID of the compartment where MySQL Instance will be created. Use alternatively to mysql_instance_compartment_name"
  default = ""
}

variable "mysql_network_compartment_ocid" {
  description = "OCID of the compartment where the network of MySQL artifact is. Use alternatively to mysql_network_compartment_name"
  default = ""
}

variable "mysql_db_system_admin_password" {
  description = "(Required) The password for the administrative user. The password must be between 8 and 32 characters long, and must contain at least 1 numeric character, 1 lowercase character, 1 uppercase character, and 1 special (nonalphanumeric) character."
}

variable "mysql_db_system_admin_username" {
  description = "(Required) The username for the administrative user."
}


variable "mysql_db_system_backup_policy_is_enabled" {
  description = "Boolean that defines if either backup is enabled or not"
  default     = false
}

variable "mysql_db_system_backup_policy_retention_in_days" {
  description = "The number of days automated backups are retained."
  default     = 7
}

variable "mysql_db_system_backup_policy_window_start_time" {
  description = "The start of a 30-minute window of time in which daily, automated backups occur. This should be in the format of the Time portion of an RFC3339-formatted timestamp. Any second or sub-second time data will be truncated to zero. At some point in the window, the system may incur a brief service disruption as the backup is performed."
  default     = ""
}

variable "mysql_db_system_data_storage_size_in_gb" {
  description = "Initial size of the data volume in GiBs that will be created and attached."
  default = 50
}



variable "mysql_db_system_description" {
  description = "User-provided data about the DB System."
  default = "iot health db"
}

variable "mysql_db_system_freeform_tags" {
  description = "Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name, type, or namespace."
  default = {}
}


variable "mysql_db_system_is_highly_available" {
  description = "Boolean that describes if either HA is enabled or not"
  default     = true
}

variable "mysql_db_system_port" {
  description = "(Optional) The port for primary endpoint of the DB System to listen on."
  default     = "3306"
}

variable "mysql_db_system_port_x" {
  description = "(Optional) The TCP network port on which X Plugin listens for connections. This is the X Plugin equivalent of port."
  default     = "33060"
}

variable "mysql_shape_name" {
  description = "(Required) The name of the shape. The shape determines the resources allocated. CPU cores and memory for VM shapes; CPU cores, memory and storage for non-VM (or bare metal) shapes. To get a list of shapes, use the ListShapes operation."
  default     = "MySQL.VM.Standard.E3.1.8GB"
}

variable "mysql_heatwave_enabled" {
  description = "Defines whether a MySQL HeatWave cluster is enabled"
  default     = false
}

variable "mysql_heatwave_cluster_size" {
  description = "Number of MySQL HeatWave nodes to be created"
  default     = 2
}

variable "mysql_heatwave_shape" {
  description = "The shape to be used instead of mysql_shape_name when mysql_heatwave_enabled = true."
  default     = "MySQL.HeatWave.VM.Standard.E3"
}

/********** MySQL Variables **********/
/********** Objectstorage Variables **********/
variable "bucket_access_type" {
  default = "NoPublicAccess"
}

variable "bucket_auto_tiering" {
  default = "Disabled"
}

variable "bucket_storage_tier" {
  default = "Standard"
}
variable "bucket_versioning" {
  default = "Disabled"
}
/********** Objectstorage Variables **********/

/********** Vault Variables **********/

variable "vault_vault_type" {
  default = "DEFAULT"
}

variable "vault_key_shape_algorithm" {
  default = "AES"
}

variable "key_key_shape_length" {
  default = 32
}

variable "vault_key_protection_mode" {
  default = "HSM"
}

variable "vault_app_env_user" {
  default = "root"
}

/********** Vault Variables **********/

/********** Compute Variables **********/
variable "compute_name" {
  default = "bastion hosts"
}
variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E4.Flex"
}
variable "instance_shape_ocpus" {
  default = 1
}

variable "instance_shape_memory_in_gbs" {
  default = 1
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "8"
}
variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbm5o7Y0AsLJdSWhsWRiDiNQam/2MB5L5NX+glKna9UGl4yQ19jSlJgXalcpuKQ/FrCrlW6PQkDVl0U5FeKqRigMAgVj4nUlWASvERsIXXtjpWJ7f9Fc1THCwi0GPDIvdM9BQwWcSBTolsN/M/GjFMO7u4t6a7iA/LeEKxWPlJdGC+tKosZO1KJFykva4VKTdOmXNySXHEjltH9SsdC9Kdz/X4R7YfwUA2h2TPmJEX0ZIueu2SeaBj6A1YCAP1k/RqPX3QhPdGYQp99mSyIGkvNt4lKewRsGyC3JnaG4o7vyY87NXWAnvNAxUjILEFt17J3k6y8nEIIq5BiOVEEnHF rahul_m_r@0a81408776aa"
}
/********** Compute Variables **********/

/********** Stream Variables **********/
variable "stream_partition_count" {
  default = 1 #10
}

variable "stream_retention_in_hours" {
  default = 24
}
/********** Stream Variables **********/

/********** Queue Variables **********/
variable "oci_queue_ocid" {

}
/********** Queue Variables **********/

/********** SMTP Variables **********/

variable "auth_profile" {
  default = "InstancePrincipal"
}

variable "email_domain_name" {
  default = "demo.com"
}

variable "sender_email_address" {
  default = "oci-wearable-app@demo.com"
}
variable "smtp_user_ocid" {
  description = "smtp user ocid"
}
/********** SMTP Variables **********/

/********** Artifact repo Variables **********/
variable "artifact_name" {
  default = "script.sql"
}
variable "artifact_version" {
  default = "0.0.0"
}
/********** Artifact repo Variables **********/
/********** Dataflow  Variables **********/
variable "dataflow_arguments" {
  default = []
}
variable "dataflow_mainclass" {
  default = "com.oracle.cloud.wearable.streaming.analytics.HealthEventAnalysis"
}
variable "dataflow_authmode" {
  default = "resource_principal"
}

variable "dataflow_maxExecutors" {
  default = "4"
}
 variable "dataflow_minExecutors" {
   default = "2"
 }
variable "dataflow_driver_shape" {
  default = "VM.Standard.E4.Flex"
}
variable "dataflow_executor_shape" {
  default = "VM.Standard.E4.Flex"
}
variable "dataflow_num_executors" {
  default = 2
}
variable "dataflow_spark_version" {
  default = "3.2.1"
}
variable "dataflow_type" {
  default = "STREAMING"
}

variable "dataflow_driver_shape_config_memory_in_gbs" {
  default = 64
}
variable "dataflow_driver_shape_config_ocpus" {
  default = 8
}

variable "dataflow_executor_shape_config_memory_in_gbs" {
  default = 32
}
variable "dataflow_executor_shape_config_ocpus" {
  default = 4
}

/********** Dataflow  Variables **********/

/********** Devops Variables **********/
variable "container_repository_is_public" {
  default = true
}

variable "deploy_artifact_argument_substitution_mode" {
  default = "SUBSTITUTE_PLACEHOLDERS"
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_description" {
  default = "DevOps CI/CD Sample Project for IOT Wearable app"
}

variable "repository_name" {
  default = "java-oci-wearable"
}

variable "repository_default_branch" {
  default = "main"
}

variable "repository_description" {
  default = "OCI Wearable APP Code base"
}

variable "git_branch" {
  default = "release/1.0.0"
}

variable "git_repo" {
  default = "https://github.com/oracle-devrel/oci-wearable-health-app"
}

variable "git_repo_name" {
  default = "oci-wearable-health-app" #It must be same as that of actual github reponame.
}

variable "buildparam_baseimage_notificationservice" {
  default = "adoptopenjdk/openjdk8"
}
locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.current_region.regions[0], "key")), ".ocir.io"])
  #ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.home_region.regions[0], "key")), ".ocir.io"])
  #ocir_namespace = lookup(data.oci_identity_tenancy.oci_tenancy, "name" )
  ocir_namespace = lookup(data.oci_objectstorage_namespace.ns, "namespace")
}

variable "repository_repository_type" {
  default = "HOSTED"
}

variable "build_pipeline_stage_build_pipeline_stage_type" {
  default = "BUILD"
}

variable "build_pipeline_stage_build_source_collection_items_connection_type" {
  default = "DEVOPS_CODE_REPOSITORY"
}

variable "build_pipeline_stage_build_source_collection_items_branch" {
  default = "main"
}

variable "build_pipeline_stage_build_source_collection_items_name" {
  default = "source"
}
variable "notification_buildspec" {
  default = "/notification-service/build_spec.yaml"
}
variable "tcpserver_buildspec" {
  default = "/tcp-server/build_spec.yaml"
}
variable "adminapi_buildspec" {
  default = "/admin-api/build_spec.yaml"
}

variable "adminapi_authorizer_buildspec" {
  default = "/admin-api-authorizer/build_spec.yaml"
}

variable "dataflow_buildspec" {
  default = "/healtheventanalysis/build_spec.yaml"
}

variable "dbsetup_buildspec" {
  default = "/DB-Setup/build_spec.yaml"
}
variable "build_pipeline_stage_display_name" {
  default = "Managed Build of Application"
}
variable "build_pipeline_stage_image" {
  default = "OL7_X86_64_STANDARD_10"
}
variable "build_pipeline_stage_wait_criteria_wait_duration" {
  default = "waitDuration"
}

variable "build_pipeline_stage_wait_criteria_wait_type" {
  default = "ABSOLUTE_WAIT"
}

variable "build_pipeline_stage_stage_execution_timeout_in_seconds" {
  default = 36000
}

variable "build_pipeline_stage_deliver_artifact_stage_type" {
  default = "DELIVER_ARTIFACT"
}

variable "deliver_artifact_stage_display_name" {
  default = "Deliver Artifacts"
}

variable "build_pipeline_stage_deploy_stage_type" {
  default = "TRIGGER_DEPLOYMENT_PIPELINE"
}

variable "deploy_stage_display_name" {
  default = "Invoke Deployment"
}

variable "build_pipeline_stage_is_pass_all_parameters_enabled" {
  default = true
}
variable "oke_deploy_rollback_policy" {
  default = "AUTOMATED_STAGE_ROLLBACK_POLICY"
}
variable "oke_namespace" {
  default = "svc"
}

variable "oke_externalsecret_operator_url" {
  default = "https://charts.external-secrets.io"
}

variable "metric_server_version" {
  default = "v0.6.1"
}

