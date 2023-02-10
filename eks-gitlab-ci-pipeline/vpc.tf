provider "aws" {
  #shared_config_files      = ["../../../.aws/config"]
  #shared_credentials_files = ["../../../.aws/credentials"]
  #profile                  = "viewics-poc"
  region = "${var.region}"
}

terraform {
  backend "s3" {
    #profile = "viewics-poc"
    encrypt = true   
    bucket = "ninad-poc"
    #dynamodb_table = "terraform-state-lock-dynamo"
    key    = "output/terraformeks.tfstate"
    region = "eu-central-1"
  }
}

/*terraform {
  backend "s3" {
    bucket  = "ninad-poc"
    key     = "output/ekstest.tfstate"
    region  = "eu-central-1"
  }
}*/



data "aws_availability_zones" "available" {}

locals {
  cluster_name = "ekstest"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "${var.vpc}"
  cidr                 = "${var.vpc_cidr}"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${var.private_subnet1}", "${var.private_subnet2}", "${var.private_subnet3}"]
  public_subnets       = ["${var.public_subnet1}", "${var.public_subnet2}", "${var.public_subnet3}"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
