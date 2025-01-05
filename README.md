# aws-vpc-bootstrap

Create a simple AWS VPC Setup with Private and Public Subnets using Terraform

## Usage 

```hcl
module "vpc" {
  source     = "github.com/diego-rodriguez-dev/aws-vpc-bootstrap"
  aws_region = "eu-central-1"
  vpc_cidr   = "10.0.0.0/16"
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

````
## Inputs
| Name | Description | Type | Default | Required |
| ---  | ---         | ---  | ----    | ------   |
| aws_region | the aws region where the VPC will be deployed         | String  | n/a    | true   |
| vpc_cidr  | The CIDR Block for the VPC | String  | n/a   | true  |
| public_subnets_config | Configuration for the Public Subnets to be created | list(objects)  | []    | true   |
| private_subnets_config  | Configuration for the Private Subnets to be created |list(objects)  | []    | true  |
| create_nat_gateway |  Flag to create NAT Gateways | Boolean  | false    | true   |
| environment  | Environemnt Name like "dev" | "test" | "prod" , etc | String  | "test"    | false  |


## Outputs
