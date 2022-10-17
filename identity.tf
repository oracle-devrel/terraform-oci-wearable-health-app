
## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

## Dynamic Groups

resource "oci_identity_dynamic_group" "dg_instances" {
  provider       = oci.home_region
  name           = "${var.app_name}_instances_dg_${random_id.tag.hex}"
  description    = "Instances  pipeline dynamic group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "Any {All {instance.compartment.id = '${var.compartment_ocid}'},ALL {resource.type = 'fnfunc',resource.compartment.id = '${var.compartment_ocid}'}}"
}

resource "oci_identity_dynamic_group" "dg_devops" {
  provider       = oci.home_region
  name           = "${var.app_name}_devops_dg_${random_id.tag.hex}"
  description    = "DevOps  pipeline dynamic group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "Any {ALL {resource.type = 'instance-family', resource.compartment.id = '${var.compartment_ocid}'},ALL {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'},ALL {resource.type = 'devopsrepository', resource.compartment.id = '${var.compartment_ocid}'},ALL {resource.type = 'devopsbuildpipeline',resource.compartment.id = '${var.compartment_ocid}'}}"
}

resource "oci_identity_dynamic_group" "dg_dataflow" {
  provider       = oci.home_region
  name           = "${var.app_name}_dataflow_dg_${random_id.tag.hex}"
  description    = "DevOps  pipeline dynamic group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'dataflowrun', resource.compartment.id = '${var.compartment_ocid}'}"
}

## Policies

resource "oci_identity_policy" "policy" {
  provider       = oci.home_region
  name           = "${var.app_name}_policies${random_id.tag.hex}"
  description    = "policy created ${var.app_name}"
  compartment_id = var.compartment_ocid

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_instances.name} to manage log-content in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_instances.name} to manage secret-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_instances.name} to manage all-resources in compartment id ${var.compartment_ocid}",
    "Allow any-user to use fn-invocation in compartment id ${var.compartment_ocid} where ALL {request.principal.type='ApiGateway', request.resource.compartment.id='${var.compartment_ocid}'}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_instances.name} to manage stream-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_instances.name} to manage streampools in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage repos in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage devops-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage ons-topics in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to read all-artifacts in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage cluster-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage secret-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage functions-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to manage virtual-network-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to use cabundles in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_devops.name} to use network-security-groups in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dg_dataflow.name} to use all-resources in compartment id ${var.compartment_ocid}"
     ]
}
