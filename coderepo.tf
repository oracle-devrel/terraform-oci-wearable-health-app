## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_repository" "test_repository" {
  #Required
  name       = var.repository_name
  project_id = oci_devops_project.test_project.id

  #Optional
  default_branch = var.repository_default_branch
  description    = var.repository_description

  repository_type = var.repository_repository_type
}


resource "null_resource" "clonerepo" {

  depends_on = [oci_devops_project.test_project, oci_devops_repository.test_repository]

  provisioner "local-exec" {
    command = "echo '(1) Cleaning local repo: '; rm -rf ${oci_devops_repository.test_repository.name}"
  }

  provisioner "local-exec" {
    command = "echo '(2) Repo to clone: https://devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name}'"
  }

  #provisioner "local-exec" {
  #  command = "echo '(3) Preparing git-askpass-helper script... '; current_dir=$PWD; chmod +x $current_dir/git-askpass-helper.sh"
  #}

  provisioner "local-exec" {
    command = "echo '(3) Starting git clone command... '; echo 'Username: Before' ${var.oci_user_name}; echo 'Username: After' ${local.encode_user}; echo 'auth_token' ${local.auth_token}; git clone https://${local.encode_user}:${local.auth_token}@devops.scmservice.${var.region}.oci.oraclecloud.com/namespaces/${local.ocir_namespace}/projects/${oci_devops_project.test_project.name}/repositories/${oci_devops_repository.test_repository.name};"
  }

  provisioner "local-exec" {
    command = "echo '(4) Finishing git clone command: '; ls -latr ${oci_devops_repository.test_repository.name}"
  }
}

resource "null_resource" "clonefromgithub" {
  depends_on = [oci_devops_repository.test_repository]

  provisioner "local-exec" {
    command = "rm -rf ./${var.git_repo_name}"
  }

  provisioner "local-exec" {
    command = "git clone -b ${var.git_branch} ${var.git_repo};"
  }
}

resource "null_resource" "update_placeholders" {
  depends_on = [null_resource.clonefromgithub,
    null_resource.clonerepo,
    oci_kms_vault.vault,
    oci_kms_key.vault_master_key,
    oci_vault_secret.auth-token,
    oci_vault_secret.db_password,
    oci_vault_secret.db_source_env_password,
    oci_vault_secret.db_source_env_url,
    oci_vault_secret.db_source_env_user,
    oci_vault_secret.hmac_key_secret_jwt,
    oci_vault_secret.smtp_password,
    oci_artifacts_container_repository.container_repository_notification,
    oci_artifacts_container_repository.container_repository_tcpserver,
    oci_devops_deploy_artifact.tcpserver_service_image]
  provisioner "local-exec" {
    environment = {
      DATA_SOURCE_URL_OCID_VALUE = oci_vault_secret.db_source_env_url.id
      DATA_SOURCE_USER_OCID_VALUE = oci_vault_secret.db_source_env_user.id
      DATA_SOURCE_PASS_OCID_VALUE = oci_vault_secret.db_source_env_password.id
      HMAC_KEY_SECRET_OCID_VALUE = oci_vault_secret.hmac_key_secret_jwt.id
      NOTIFICATION_IMAGE_REPO_URL = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_notification.display_name}"
      BUILDRUN_HASH = "$${BUILDRUN_HASH}"
      DB_NAME = "$${DB_NAME}"
      DB_HOST = "$${DB_HOST}"
      STREAM_MESSAGING_ENDPOINT = "$${STREAM_MESSAGING_ENDPOINT}"
      STREAM_OCID = "$${STREAM_OCID}"
      AUTH_PROFILE = "$${AUTH_PROFILE}"
      TCP_SERVER_PORT = "$${TCP_SERVER_PORT}"
      QUEUE_OCID = "$${QUEUE_OCID}"
      QUEUE_REGION_ID = "$${QUEUE_REGION_ID}"
      SMTP_USERNAME = "$${SMTP_USERNAME}"
      SMTP_PASSWORD_OCID = "$${SMTP_PASSWORD_OCID}"
      EMAIL_HOST = "$${EMAIL_HOST}"
      EMAIL_FROM_ADDRESS = "$${EMAIL_FROM_ADDRESS}"
      DB_PASSWORD_VALUE = "$${DB_PASSWORD_VALUE}"
      OCI_PRIMARY_SOURCE_DIR = "$${OCI_PRIMARY_SOURCE_DIR}"
      MYSQL_RPM_VERSION = "$${MYSQL_RPM_VERSION}"
      OCI_BUILD_RUN_ID = "$${OCI_BUILD_RUN_ID}"
      TCPSERVER_IMAGE_REPO_URL = "${local.ocir_docker_repository}/${local.ocir_namespace}/${oci_artifacts_container_repository.container_repository_tcpserver.display_name}"
      VAULT_OCID = oci_kms_vault.vault.id
      REGION_ID = var.region
      DB_USERNAME = var.mysql_db_system_admin_username
      DB_PORT = var.mysql_db_system_port
      DB_SERVER = oci_mysql_mysql_db_system.mysql_db.ip_address

    }
    command = <<-EOT
      cat ${path.module}/${var.git_repo_name}/admin-api/func.yaml|envsubst > ${path.module}/${var.git_repo_name}/admin-api/func.yaml.tmp
      mv ${path.module}/${var.git_repo_name}/admin-api/func.yaml.tmp ${path.module}/${var.git_repo_name}/admin-api/func.yaml
      cat ${path.module}/${var.git_repo_name}/admin-api-authorizer/func.yaml|envsubst >${path.module}/${var.git_repo_name}/admin-api-authorizer/func.yaml.tmp
      mv ${path.module}/${var.git_repo_name}/admin-api-authorizer/func.yaml.tmp ${path.module}/${var.git_repo_name}/admin-api-authorizer/func.yaml
      cat ${path.module}/${var.git_repo_name}/external-secret-manifest/es-manifest.yaml|envsubst>${path.module}/${var.git_repo_name}/external-secret-manifest/es-manifest.yaml.tmp
      mv ${path.module}/${var.git_repo_name}/external-secret-manifest/es-manifest.yaml.tmp ${path.module}/${var.git_repo_name}/external-secret-manifest/es-manifest.yaml
      cat ${path.module}/${var.git_repo_name}/notification-service/manifest/deployment.yaml|envsubst > ${path.module}/${var.git_repo_name}/notification-service/manifest/deployment.yaml.tmp
      mv  ${path.module}/${var.git_repo_name}/notification-service/manifest/deployment.yaml.tmp ${path.module}/${var.git_repo_name}/notification-service/manifest/deployment.yaml
      cat ${path.module}/${var.git_repo_name}/tcp-server/manifest/deployment.yaml|envsubst >${path.module}/${var.git_repo_name}/tcp-server/manifest/deployment.yaml.tmp
      mv ${path.module}/${var.git_repo_name}/tcp-server/manifest/deployment.yaml.tmp ${path.module}/${var.git_repo_name}/tcp-server/manifest/deployment.yaml
      cp ${path.module}/instance_bootstrap ${path.module}/instance_bootstrap_origin
      cat ${path.module}/instance_bootstrap |envsubst >${path.module}/instance_bootstrap.tmp
      mv ${path.module}/instance_bootstrap.tmp ${path.module}/instance_bootstrap
      cat ${path.module}/manifest/dbsetup_build_spec.yaml |envsubst >${path.module}/${var.git_repo_name}/DB-Setup/build_spec.yaml
    EOT

  }
}

resource "null_resource" "copyfiles" {

  depends_on = [null_resource.update_placeholders]

  provisioner "local-exec" {
    command = "rm -rf ${var.git_repo_name}/.git; cp -pr ${var.git_repo_name}/* ${oci_devops_repository.test_repository.name}/; cd .."
  }
}


resource "null_resource" "pushcode" {

  depends_on = [null_resource.copyfiles]

  provisioner "local-exec" {
    command = <<-EOT
      cd ./${oci_devops_repository.test_repository.name}
      git_global_username=`git config --global user.name`
      git_global_mail=`git config --global user.email`
      git config user.email test@example.com
      git config user.name ${var.oci_user_name}
      git add .; git commit -m 'added latest files'
      git push origin ${var.repository_default_branch}
      git config user.email ""
      git config user.name ""

    EOT

  }
}


locals {
  encode_user = urlencode(var.oci_user_name)
  auth_token  = urlencode(var.oci_user_authtoken)
}
