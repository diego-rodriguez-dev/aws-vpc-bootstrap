variable "aws_region" {
  type = string
}

variable "environment" {
  type    = string
  default = "test"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the vpc"
}

variable "public_subnets_config" {
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  description = "Configuration for Public Subnet"
  default     = []
}

variable "private_subnets_config" {
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
  description = "Configuration for Private Subnet"
  default     = []
}

variable "create_nat_gateway" {
  type        = bool
  description = "Activate the creation of NAT Gateway"
  default     = false
}
