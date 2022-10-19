## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_apigateway_gateway" "api_gateway" {
  compartment_id             = var.compartment_ocid
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  display_name               = "${var.app_name}_api_gateway"
  endpoint_type              = "PUBLIC"
  freeform_tags              = {}
  network_security_group_ids = []
  subnet_id                  = oci_core_subnet.application_public_subnet.id


  response_cache_details {
    connect_timeout_in_ms  = 0
    is_ssl_enabled         = false
    is_ssl_verify_disabled = false

    type                   = "NONE"
  }

  timeouts {}
}

resource "oci_apigateway_deployment" "admin_api_deployment" {
  compartment_id = var.compartment_ocid
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  display_name   = "iot-admin-api"
  freeform_tags  = {}
  gateway_id     = oci_apigateway_gateway.api_gateway.id
  path_prefix    = var.path_prefix

  specification {
    logging_policies {

      execution_log {
        is_enabled = true
        log_level  = "INFO"
      }
    }

    request_policies {
      authentication {
        audiences                   = []
        cache_key                   = [
          "authorization_token",
        ]
        function_id                 = oci_functions_function.admin_api_authorizer.id
        is_anonymous_access_allowed = true
        issuers                     = []
        max_clock_skew_in_seconds   = 0
        parameters                  = {
          "authorization_token" = "request.headers[Authorization]"
        }
        type                        = "CUSTOM_AUTHENTICATION"

        validation_failure_policy {
          type = "MODIFY_RESPONSE"
        }
      }

      cors {
        allowed_headers              = [
          "Content-Type,api_key,Authorization,accept",
        ]
        allowed_methods              = [
          "GET",
          "POST",
          "OPTIONS",
        ]
        allowed_origins              = [
          "*",
        ]
        exposed_headers              = []
        is_allow_credentials_enabled = true
        max_age_in_seconds           = 0
      }

      mutual_tls {
        allowed_sans                     = []
        is_verified_certificate_required = false
      }
    }

    routes {
      methods = [
        "GET",
        "POST",
      ]
      path    = "/{api_path*}"

      backend {
        connect_timeout_in_seconds = 0
        function_id                = oci_functions_function.admin_api.id
        is_ssl_verify_disabled     = false
        read_timeout_in_seconds    = 0
        send_timeout_in_seconds    = 0
        status                     = 0
        type                       = "ORACLE_FUNCTIONS_BACKEND"
      }

      logging_policies {

        execution_log {
          is_enabled = false
        }
      }

      request_policies {
        authorization {
          allowed_scope = []
          type          = "AUTHENTICATION_ONLY"
        }
      }

      response_policies {
      }
    }
    routes {
      methods = [
        "POST",
      ]
      path    = "/login"

      backend {
        connect_timeout_in_seconds = 0
        function_id                = oci_functions_function.admin_api.id
        is_ssl_verify_disabled     = false
        read_timeout_in_seconds    = 0
        send_timeout_in_seconds    = 0
        status                     = 0
        type                       = "ORACLE_FUNCTIONS_BACKEND"
      }

      logging_policies {

        execution_log {
          is_enabled = false
        }
      }

      request_policies {
        authorization {
          allowed_scope = []
          type          = "ANONYMOUS"
        }
      }

      response_policies {
      }
    }
    routes {
      methods = [
        "POST",
      ]
      path    = "/addUser"

      backend {
        connect_timeout_in_seconds = 0
        function_id                = oci_functions_function.admin_api.id
        is_ssl_verify_disabled     = false
        read_timeout_in_seconds    = 0
        send_timeout_in_seconds    = 0
        status                     = 0
        type                       = "ORACLE_FUNCTIONS_BACKEND"
      }

      logging_policies {

        execution_log {
          is_enabled = false
        }
      }

      request_policies {
        authorization {
          allowed_scope = []
          type          = "ANONYMOUS"
        }
      }

      response_policies {
      }
    }
  }

  timeouts {}
}

