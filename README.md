# Documentation Pipeline - Terraform

Terraform is an open source tool that provides a flexible abstraction of
resources and providers. While Terraform is not a configuration management tool,
it serves a config mgmt. purpose in an immutable infrastructure such as this.

Current auth users for deployment in em-epc-dev:

  `epc-api-docserver-user-ServiceUser-1VFZDXJ931WNG`

### Deploy commands

Deploy resources with the deploy-stack script. It can be run locally, or in an automation environment.

    $ ./deploy-stack.sh -[option] <parameter-value> ...

    #  Options_|_ Parameters_|_ Descriptions _______________________________________
    #   [-f]   |  FORCE_ARG  | Force approve argument (varies depending on TF version)
    #   [-t]   |  TARGET     | Environment to which to deploy the stack (prod, dev)
    #   [-e]   |  ENABLE_EIP | Boolean elastic_ip feature toggle
    #   [-k]   |  KEY_NAME   | Name of key pair to attach to ec2 instance
    #   [-b]   |  S3_BUCKET  | Name terraform remote-state backend s3 bucket
    #   [-r]   |  REGION     | Region where desired s3 bucket resides


### Dev Notes

- Default custom AMI is located in the **us-east-2** region. Deployment may be done to other
regions as long as the AMI meets the base dependency requirements specified in this document

###### Local development / State tracking

  - elastic ip feature default is OFF. I fyou wish to associate an elastic ip with an
  instance during local or automated deploy, ***MAKE SURE TO CREATE AND SPECIFY A DIFFERENT ELASTIC IP***
  - If backend partial config arguments are not passed via cli opt/param, terraform
  will prompt user for variable values at run time.
  - If user wants to track state locally, they must comment out the following
  resource block in **main.tf**

        terraform {
          backend "s3" { }
        }

###### Automation dev/prod

  - The default state tracking config for automation is via S3 bucket.

  - Current Jenkins jobs retrieve private key via AWS CLI **ssm parameter** command
  for remote-exec/file provisioning


###### Variable configuration

  - remote-exec and file provisioning requires name of key pair associated with ec2 instance.
  This private .pem file may be stored locally or retrieved at run time by the AWS CLI **ssm parameter** command. Default for local development is to store key locally and reference absolute path in tfvars file.

### Base AMI Requirements for deployment

- **OS:**  
  - RHEL 7.*
  - CentOS 7.*
- **Network**:
  - firewalld  
  - NGINX version: 1.12.2
- Ruby **>=** version 2.3.1
- Bundler
