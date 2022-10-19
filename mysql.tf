# Copyright (c) 2022 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# mysql.tf
#
# Purpose: TThe following script defines MySQL artifact creation
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/mysql_mysql_db_system
#

resource "oci_mysql_mysql_db_system" "mysql_db" {
  admin_password      = var.mysql_db_system_admin_password
  admin_username      = var.mysql_db_system_admin_username
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain_name
  compartment_id      = var.compartment_ocid
  shape_name          = var.mysql_shape_name
  subnet_id           = oci_core_subnet.application_private_subnet.id

  dynamic "backup_policy" {
    for_each = var.mysql_db_system_backup_policy_is_enabled ? [1] : []
    content {
      is_enabled        = true
      retention_in_days = var.mysql_db_system_backup_policy_retention_in_days
    }
  }
  dynamic "backup_policy" {
    for_each = var.mysql_db_system_backup_policy_is_enabled ? [] : [1]
    content {
      is_enabled = false
    }
  }
  data_storage_size_in_gb = var.mysql_db_system_data_storage_size_in_gb
  defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  description             = var.mysql_db_system_description
  display_name            = "${var.app_name}_mysqldb"
  #fault_domain            = var.mysql_db_system_fault_domain
  freeform_tags           = var.mysql_db_system_freeform_tags
  #hostname_label          = var.mysql_db_system_hostname_label
  is_highly_available     = var.mysql_db_system_is_highly_available
#  maintenance {
#    window_start_time = var.mysql_db_system_maintenance_window_start_time
#  }
#  port   = var.mysql_db_system_port
#  port_x = var.mysql_db_system_port_x
}

##MySQL Setup.
#resource "null_resource" "mysql_setup" {
#  depends_on = [oci_mysql_mysql_db_system.mysql_db,oci_resourcemanager_private_endpoint.rms_pe_mysql]
#  provisioner "local-exec" {
#      command    = <<-EOT
#      mysql --password=${var.mysql_db_system_admin_password} --user=${var.mysql_db_system_admin_username} --port ${oci_mysql_mysql_db_system.mysql_db.port} --host=${oci_mysql_mysql_db_system.mysql_db.ip_address} <${path.module}/${var.git_repo_name}/DB-Setup/setup.sql
#  EOT
#  }
#}
