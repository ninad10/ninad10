#!/bin/bash

aws eks list-clusters --region eu-central-1

aws eks --region eu-central-1 update-kubeconfig --name cluster_name

exit


