#!/bin/bash

/home/gitlab-runner/builds/NcM5RHfU/0/navify-analytics/cloud-automation/kubectlbin/kubectl apply -f run-my-nginx.yaml

/home/gitlab-runner/builds/NcM5RHfU/0/navify-analytics/cloud-automation/kubectlbin/kubectl get pods

/home/gitlab-runner/builds/NcM5RHfU/0/navify-analytics/cloud-automation/kubectlbin/kubectl expose deployment/my-nginx --port=80 --target-port=80 --name=my-nginx-service --type=LoadBalancer

/home/gitlab-runner/builds/NcM5RHfU/0/navify-analytics/cloud-automation/kubectlbin/kubectl get svc
