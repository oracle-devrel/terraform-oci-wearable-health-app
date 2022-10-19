# terraform-oci-wearable-health-app

The repo contains terraform-based automation of a sample OCI IoT Application.
The application is an IoT use case, in which an application capturing health parameters running on a wearable device is sending health statistics to a device gateway (backend) hosted on OCI at regular intervals. The complete use case can be split into 3 different parts:



For details of the architecture, see [oci-wearable-health-app](https://github.com/oracle-devrel/oci-wearable-health-app)

## Terraform Provider for Oracle Cloud Infrastructure
The OCI Terraform Provider is now available for automatic download through the Terraform Provider Registry.
For more information on how to get started view the [documentation](https://www.terraform.io/docs/providers/oci/index.html)
and [setup guide](https://www.terraform.io/docs/providers/oci/guides/version-3-upgrade.html).

* [Documentation](https://www.terraform.io/docs/providers/oci/index.html)
* [OCI forums](https://cloudcustomerconnect.oracle.com/resources/9c8fa8f96f/summary)
* [Github issues](https://github.com/terraform-providers/terraform-provider-oci/issues)
* [Troubleshooting](https://www.terraform.io/docs/providers/oci/guides/guides/troubleshooting.html)

### ⚠️ Specific notice for service usage.

- The architecture is using the `OCI Messaging queue service`, which is in the `Limited Availability Phase`, reach out to your OCI Contact to get early access. Refer to more in the configuration section.

## Deploy Using Oracle Resource Manager

1. Click  [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-devops-cicd-instances/releases/latest/download/terraform-oci-wearable-health-app.zip)

   If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

   To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**.

### Configuration for OCI Queue service.

```java
queue name: health-alert-queue
max retention period: 7 days
deadletter queue name: health-alert-queue - DLQ
visibility timeout: 2 minutes
Max Number of delivery attempts: 5
```

### Validate the Deployment

- Post the infra deployment, use the `application_url` to access the user interface. You may refer to the stack output to fetch the URL.
- A sample stack output will be as below

```java
admin_api_endpoint = "https://xyz.apigateway.<OCI Region>.oci.customer-oci.com/admin-api"
application_url = "https://objectstorage.<OCI Region>.oraclecloud.com/n/<Name Space>/b/<UI Bucket>/o/index.html"
deploy_id = "abcd"
deployed_oke_kubernetes_version = "v1.24.1"
deployed_to_region = "<OCI Region>"
dev = "Made with ❤ by Oracle Developers"
generated_private_key_pem = <sensitive>
kubeconfig_for_kubectl = "export KUBECONFIG=./generated/kubeconfig"

```



## Deploy Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

```java

    git clone https://github.com/oracle-devrel/terraform-oci-wearable-health-app
    cd terraform-oci-wearable-health-app
    ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Secondly, create a `terraform. tfvars` file and populate it with the following information:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"

# OCI User and Authtoken
oci_user_name       = "<oci_username> 
# For a federated user (single sign-on with an identity provider), enter the username in the following format: TenancyName/Federation/UserName. 
# For example, if you use OCI's identity provider, your login would be, Acme/oracleidentitycloudservice/alice.jones@acme.com. 
#If you are using OCI's direct sign-in, enter the username in the following format: TenancyName/YourUserName. For example, Acme/alice_jones. Your password is the auth token you created previously.

oci_user_authtoken = "<oci_user_authtoken>" 
# You can get the auth token from your Profile menu -> click User Settings -> On the left side  click *Auth Tokens -> Generate Token

#My Application Related variables

mysql_db_system_admin_username = "<mysql_db_system_admin_username>"
mysql_db_system_admin_password = "<mysql_db_system_admin_password>"
oci_queue_ocid = "<oci_queue_ocid>"
smtp_user_ocid = "<smtp_user_ocid>"


````

Deploy:

    terraform init
    terraform plan
    terraform apply



## Destroy the Deployment
- Delete all the artifacts within the `OCI Artifact repository` then follow terraform command and destroy.
- Delete any additional resources (load balancers, PVs, Secrets, Private Endpoints .. ) created using the terraform provisioned components using the console.
- Vault will change into a `pending deletion` state after the destroy execution.

```java
terraform destroy
```


## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open-source community.

### Attribution & Credits
- Rahul M R (https://github.com/RahulMR42)

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See LICENSE for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE. FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK.

