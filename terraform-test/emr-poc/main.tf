terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["../../.aws/config"]
  shared_credentials_files = ["../../.aws/credentials"]
  profile                  = "default"
}

terraform {
  backend "s3" {
    bucket  = "{s3-bucketname}n"
    key     = "output/emrstate.tfstate"
    region  = "{aws-regionname}"
  }
}


resource "aws_emr_cluster" "cluster" {
  name           = "${var.name}"
  release_label  = "${var.release_label}"
  applications   = "${var.applications}"
  termination_protection = true  
  autoscaling_role ="${var.autoscaling_role}"
  #configurations_json = file(var.configurations_json)
  log_uri      = "${var.log_uri}"
  service_role = "${var.service_role}"
  bootstrap_action {
    path = "s3://${var.emrs3LogUri}/bootstrap-scriptURI"
    name = "Install Spark Binaries"
  }
  configurations_json = <<EOF
  [{
		"Classification": "hdfs-site",
				"Properties": {
					"dfs.namenode.acls.enabled": "true"
				}
		},
	  {
		"Classification": "hue-ini",
				"Properties": {
					"time_zone": "Etc/UTC"
				}
  	},
	  {
		"Classification": "yarn-site",
				"Properties": {
					"yarn.log-aggregation.retain-seconds": "604800",
					"yarn.nodemanager.vmem-check-enabled": "false"
				}
    },
	  {
		"Classification": "livy-conf",
				"Properties": {

					"livy.server.session.timeout-check": "true",
					"livy.server.session.timeout": "10h",
					"livy.server.yarn.app-lookup-timeout": "120s"
				}
	  },
	  {
		"Classification": "spark-defaults",
				"Properties": {
					"spark.executor.memory": "8G"
				}
	  },
	  {
		"Classification": "spark-hive-site",
				"Properties": {
					"hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
				}
	  }
]
EOF
  
 /* 
  dynamic "step" {
    for_each = jsondecode(templatefile("${var.steps}", {}))
    content {
      action_on_failure = step.value.action_on_failure
      name              = step.value.name
      hadoop_jar_step {
        jar  = step.value.hadoop_jar_step.jar
        args = step.value.hadoop_jar_step.args
      }
    }
  }*/


  step_concurrency_level = "${var.step_concurrency_level}"


  ec2_attributes {
    key_name                          = "${var.key_name}"
    subnet_id                         = "${var.subnet_id}"
    emr_managed_master_security_group = "${var.emr_managed_master_security_group}"
    emr_managed_slave_security_group  = "${var.emr_managed_slave_security_group}"
    service_access_security_group = "${var.service_access_security_group}"
    instance_profile               = "${var.instance_profile}"
  }


    master_instance_group {
      name           = "${var.master_instance_group_name}"
      instance_type  = "${var.master_instance_group_instance_type}"
      instance_count = "${var.master_instance_group_instance_count}"
      #bid_price      = "${var.master_instance_group_bid_price}"    
      /*ebs_config {
                    iops = "${var.master_instance_group_ebs_iops}"
                    size = "${var.master_instance_group_ebs_size}"
                    type = "${var.master_instance_group_ebs_type}"
                    volumes_per_instance = "${var.master_instance_group_ebs_volumes_per_instance}"
                    }*/

    

/*step {
      action_on_failure = "CONTINUE"
      name              = "Setup Hadoop Debugging"

      hadoop_jar_step = [
        {
          jar = "command-runner.jar"
          args = [
            "state-pusher-script"
          ]
          main_class = ""
          properties = {}
        }
      ]
    }*/
}


core_instance_group {
  
      name           = "${var.core_instance_group_name}"
      instance_type  = "${var.core_instance_group_instance_type}"
      instance_count = "${var.core_instance_group_instance_count}"
      #bid_price      = "${var.core_instance_group_bid_price}"    #Do not use core instances as Spot Instance in Prod because terminating a core instance risks data loss.
      /*ebs_config {
                    iops = "${var.core_instance_group_ebs_iops}"
                    size = "${var.core_instance_group_ebs_size}"
                    type = "${var.core_instance_group_ebs_type}"
                    volumes_per_instance = "${var.core_instance_group_ebs_volumes_per_instance}"
                    }*/
      #autoscaling_policy = file("${var.core_instance_group_autoscaling_policy}")
}
 
  tags = {
    Name        = "${var.name}"
    Project     = "${var.project}"
    Environment = "${var.environment}"


  }


  

  step {
    action_on_failure  = "CONTINUE"
    name   = "Setup Hadoop Debugging"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["state-pusher-script"]
    }
  }

  # Optional: ignore outside changes to running cluster steps
  lifecycle {
    ignore_changes = ["step"]
  }
}


resource "aws_emr_instance_group" "task_instance_group" {
  
      name           = "${var.task_instance_group_name}"
      cluster_id = join("", aws_emr_cluster.cluster.*.id)
      instance_type  = "${var.task_instance_group_instance_type}"
      instance_count = "${var.task_instance_group_instance_count}"
      #autoscaling_policy = "${var.task_instance_group_autoscaling_policy}"
      #bid_price      = "${var.task_instance_group_bid_price}"    #Spot Instances are preferred  in Prod
      #configurations_json = file(var.configurations_json)
      autoscaling_policy = file("${var.task_instance_group_autoscaling_policy}")
      /*ebs_config {
                    iops = "${var.task_instance_group_ebs_iops}"
                    size = "${var.task_instance_group_ebs_size}"
                    type = "${var.task_instance_group_ebs_type}"
                    volumes_per_instance = "${var.task_instance_group_ebs_volumes_per_instance}"
                    } */      

  /*autoscaling_policy = <<EOF
  {
  "Constraints": {
    "MinCapacity": 1,
    "MaxCapacity": 3
  },
  "Rules": [
    {
      "Name": "TaskNode-ScaleOutMemoryPercentage",
      "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
      "Action": {
        "SimpleScalingPolicyConfiguration": {
          "AdjustmentType": "CHANGE_IN_CAPACITY",
          "ScalingAdjustment": 1,
          "CoolDown": 300
        }
      },
      "Trigger": {
        "CloudWatchAlarmDefinition": {
          "ComparisonOperator": "LESS_THAN",
          "EvaluationPeriods": 1,
          "MetricName": "YARNMemoryAvailablePercentage",
          "Namespace": "AWS/ElasticMapReduce",
          "Period": 300,
          "Statistic": "AVERAGE",
          "Threshold": 15.0,
          "Unit": "PERCENT"
        }
      }
    }
,
    {
    "Name": "ScaleInMemoryPercentage",
    "Description": "Scale in if YARNMemoryAvailablePercentage is greter than 50",
    "Action": {
    "SimpleScalingPolicyConfiguration": {
    "AdjustmentType": "CHANGE_IN_CAPACITY",
    "ScalingAdjustment": -1,
    "CoolDown": 300
    }
    },
    "Trigger": {
    "CloudWatchAlarmDefinition": {
    "ComparisonOperator": "GREATER_THAN_OR_EQUAL",
    "EvaluationPeriods": 1,
    "MetricName": "YARNMemoryAvailablePercentage",
    "Namespace": "AWS/ElasticMapReduce",
    "Period": 300,
    "Statistic": "AVERAGE",
    "Threshold": 75.0,
    "Unit": "PERCENT"
    }
    }
}
  ]
}
EOF
*/

      
}
