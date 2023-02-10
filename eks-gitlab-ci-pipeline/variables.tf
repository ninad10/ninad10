
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
  default     = "t2.xxxxxx"
  description = "Instance type"
}

variable "volume-type" {
  default     = "gp2"
  description = "Instance type"
}

variable "vpc" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "xxxxx"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "xxxxxxx/16"
}

variable "cidr_blocks1" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "xxxxxx/8"
}

variable "cidr_blocks2" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "xxxxx/16"
}

variable "cidr_blocks3" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "xxxxx/12"
}


variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}


variable "private_subnet1" {
  description = "private subnet range"
  default = "xxxxx/24"
}

variable "private_subnet2" {
  description = "private subnet range"
  default = "xxxxxx/24"
}

variable "private_subnet3" {
  description = "private subnet range"
  default = "xxxxxx/24"
}

variable "public_subnet1" {
  description = "public subnet range"
  default = "xxxxxx/24"
}

variable "public_subnet2" {
  description = "public subnet range"
  default = "xxxxxx/24"
}

variable "public_subnet3" {
  description = "public subnet range"
  default = "xxxxxxx/24"
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
