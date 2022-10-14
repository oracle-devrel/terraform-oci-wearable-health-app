## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_kms_vault" "vault" {
  #Required
  compartment_id = var.compartment_ocid
  display_name = "${var.app_name}_vault"
  vault_type = var.vault_vault_type

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

resource "oci_kms_key" "vault_master_key" {
  #Required
  compartment_id = var.compartment_ocid
  display_name = "${var.app_name}_vault_masterkey"
  key_shape {
    #Required
    algorithm = var.vault_key_shape_algorithm
    length = var.key_key_shape_length
  }
  management_endpoint = oci_kms_vault.vault.management_endpoint

  #Optional
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  protection_mode = "${var.vault_key_protection_mode}"
}

resource oci_vault_secret "hmac_key_secret_jwt" { #256 string
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(random_string.hmac_jwt_string.result)
  }
  secret_name    = "HMAC_KEY_SECRET"
  vault_id       = oci_kms_vault.vault.id
}

resource oci_vault_secret "db_password" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.mysql_db_system_admin_password)
  }
  secret_name    = "DB_PSWD" #It must be the same name as that of external secret key.
  vault_id       = oci_kms_vault.vault.id
}


resource oci_vault_secret "db_source_env_url" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode("jdbc:mysql://${oci_mysql_mysql_db_system.mysql_db.ip_address}:${var.mysql_db_system_port}/health_app?useUnicode=yes&characterEncoding=UTF-8")
  }
  secret_name    = "data_source_env_setUrl"
  vault_id       = oci_kms_vault.vault.id
}

resource oci_vault_secret "db_source_env_user" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.vault_app_env_user)
  }
  secret_name    = "data_source_env_setUser"
  vault_id       = oci_kms_vault.vault.id
}

resource oci_vault_secret "db_source_env_password" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.mysql_db_system_admin_password)
  }
  secret_name    = "data_source_env_setPassword"
  vault_id       = oci_kms_vault.vault.id
}

resource oci_vault_secret "smtp_password" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(oci_identity_smtp_credential.test_smtp_credential.password)
  }
  secret_name    = "smtp_access_password"
  vault_id       = oci_kms_vault.vault.id
}



resource oci_vault_secret "auth-token" {
  compartment_id = var.compartment_ocid
  key_id = oci_kms_key.vault_master_key.id
  secret_content {
    content_type = "BASE64"
    content = base64encode(var.oci_user_authtoken)
  }
  secret_name    = "auth-token"
  vault_id       = oci_kms_vault.vault.id
}
