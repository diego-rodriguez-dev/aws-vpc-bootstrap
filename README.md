# aws-vpc-bootstrap

Create a simple AWS VPC Setup with Private and Public Subnets using Terraform.

This module will created the following ressources in your AWS account:



- A new VPC 

- Private Subnets

- Public Subnets

- Route Tables

- Internet Gateway

- Nat Gateways



## Requirements

- Terraform v1.10.1 or higher

- An AWS Account where the ressources can be deployed.

## Usage

This is an example on how to you can create a VPC using this module.

```hcl
module "vpc" {
  source             = "github.com/diego-rodriguez-dev/aws-vpc-bootstrap"
  aws_region         = "eu-central-1"
  vpc_cidr           = "10.0.0.0/16"
  create_nat_gateway = true
  public_subnets_config = [
    {
      cidr              = "10.0.0.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr              = "10.0.2.0/24"
      availability_zone = "eu-central-1b"

    }
  ]
  private_subnets_config = [
    {
      cidr              = "10.0.1.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr              = "10.0.3.0/24"
      availability_zone = "eu-central-1b"

    }
  ]
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID for the created VPC"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "ID's for the created private subnets"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "ID's for the created private subnets"
}
```

To validate to the terraform code run:

```bash
terraform validate
```

To deploy the VPC run:

```bash
terraform apply
```

**important:** If you are only testing this module, don't forget destroy the ressources to avoid any unnecesary costs. To achieve this run:

```bash
terraform destroy
```

more configuration examples can be found in the **/examples** folder.

## Inputs

| Name                   | Description                                         | Type          | Default      | Required |
| ---------------------- | --------------------------------------------------- | ------------- | ------------ | -------- |
| aws_region             | the aws region where the VPC will be deployed       | String        | n/a          | true     |
| vpc_cidr               | The CIDR Block for the VPC                          | String        | n/a          | true     |
| public_subnets_config  | Configuration for the Public Subnets to be created  | list(objects) | []           | true     |
| private_subnets_config | Configuration for the Private Subnets to be created | list(objects) | []           | true     |
| create_nat_gateway     | Flag to create NAT Gateways                         | Boolean       | false        | true     |
| environment            | Environemnt Name like "dev"                         | "test"        | "prod" , etc | String   |

## Outputs

| Name               | Description                                  | Type         |
| ------------------ | -------------------------------------------- | ------------ |
| vpc_id             | id for the created VPC                       | String       |
| private_subnet_ids | List of ID's for the created private subnets | list(String) |
| public_subnet_ids  | List of ID's for the created public  subnets | list(String) |
