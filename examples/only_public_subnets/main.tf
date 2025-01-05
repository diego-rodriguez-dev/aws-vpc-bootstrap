module "vpc" {
  source     = "../../"
  aws_region = "eu-central-1"
  vpc_cidr   = "10.0.0.0/16"
  public_subnets_config = [
    {
      cidr              = "10.0.0.0/24"
      availability_zone = "eu-central-1a"
    },
    {
      cidr              = "10.0.1.0/24"
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
