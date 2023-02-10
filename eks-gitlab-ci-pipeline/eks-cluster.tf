module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.24"
  subnets         = module.vpc.private_subnets
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  tags = merge(
    var.tags
  )

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "${var.volume-type}"
  }

/*remote_access = {
   ec2_ssh_key               = module.key_pair.key_pair_name
   source_security_group_ids = [aws_security_group.remote_access.id]
  }*/

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "${var.instance-type}"
      additional_userdata           = "echo foo bar"
      key_name                      = "xxxxxx"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "${var.instance-type}"
      additional_userdata           = "echo foo bar"
      key_name                      = "xxxxxx"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
