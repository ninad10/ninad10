
variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "instance-type" {
  default     = "t2.medium"
  description = "Instance type"
}

variable "volume-type" {
  default     = "gp2"
  description = "Instance type"
}

variable "vpc" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "ekstest"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_blocks1" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/8"
}

variable "cidr_blocks2" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "192.168.0.0/16"
}

variable "cidr_blocks3" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "172.16.0.0/12"
}


variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}


variable "private_subnet1" {
  description = "private subnet range"
  default = "10.0.1.0/24"
}

variable "private_subnet2" {
  description = "private subnet range"
  default = "10.0.2.0/24"
}

variable "private_subnet3" {
  description = "private subnet range"
  default = "10.0.3.0/24"
}

variable "public_subnet1" {
  description = "public subnet range"
  default = "10.0.4.0/24"
}

variable "public_subnet2" {
  description = "public subnet range"
  default = "10.0.5.0/24"
}

variable "public_subnet3" {
  description = "public subnet range"
  default = "10.0.6.0/24"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSAutomation"
    "Environment" = "POC"
    "Owner"       = "Ninad Rathkanthiwar"
  }
}