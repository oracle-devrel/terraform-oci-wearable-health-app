## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = var.VCN-CIDR
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}-VCN-${random_string.deploy_id.result}"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_ocid
  display_name   = "internet-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create route table to connect vcn to internet gateway

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "sl" {
  compartment_id = var.compartment_ocid
  display_name   = "security-list"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }

      ingress_security_rules {
        protocol = "6"
        source   = "10.100.0.0/16"

        tcp_options {
          max = 3306
          min = 3306
        }
      }
        ingress_security_rules {
          protocol = "6"
          source   = "10.0.0.0/16"

          tcp_options {
            max = 3306
            min = 3306
          }
        }

        ingress_security_rules {
          protocol = "1"
          source   = "10.0.0.0/16"

        }


  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create regional subnets in vcn

resource "oci_core_subnet" "application_public_subnet" {
  cidr_block        = var.Public-Subnet-CIDR
  display_name      = "PublicSubnet-Application-VCN"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]

  provisioner "local-exec" {
    command = "sleep 5"
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "application_private_subnet" {
  cidr_block        = var.Private-Subnet-CIDR
  display_name      = "PrivateSubnet-Application-VCN"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]
  prohibit_public_ip_on_vnic = true
  provisioner "local-exec" {
    command = "sleep 5"
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_local_peering_gateway" "test_local_peering_gateway_2" {
  compartment_id    = var.compartment_ocid
  vcn_id = oci_core_virtual_network.vcn.id
  display_name = "Local peering to OKE VCN"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}