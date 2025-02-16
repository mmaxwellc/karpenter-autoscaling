# karpenter-autoscaling

This repository contains the full infrastructure code (in terraform) That automates AWS EKS cluster setup with karpenter while utilizing graviton and spot instances


STEP 1: Infrastructure provisioning

To run the Terraform code: 

a. Go into terraform root module folder
cd infra/environment/dev

b. Iniialize terraform
run command "terraform init"

c. Plan terraform script
run command "terraform plan"

d. Deploy terraform script
run command "terraform apply --auto-approve"

Once it is deployed successfully, the cluster is ready to run your applications and scale it efficiently 


STEP 2: run your pod/deployment

a. Go into the Deployment folder
    cd Deployment

b. run your deployment (note: Be sure you have access to the eks cluster before running the deployment)
    kubectl apply -f application1.yml

The application gets deployed into the cluster which is running Graviton instance,
any new application to be deployed will follow same deployment step.


NOTE: This whole process can further be automated using CI/CD, automating Infra with GitHub actions and terraform cloud, And automating Deployment with GitHub action, Helm chart and ArgoCD



