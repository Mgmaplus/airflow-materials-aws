#!/bin/bash

# Create a new folder rbac in airflow-eks-config
# to deploy RBACS roles and role binding required by the AWS Ingress controller
mkdir -p airflow-eks-config/iam

cp airflow-materials-aws/section-7/iam/airflow-rbac-role-alb-ingress.yml \
    airflow-eks-config/iam

cd airflow-eks-config
git add .
git commit -am "add iam for the Ingress controller"
git push

fluxctl sync --k8s-fwd-ns flux

# Create an IAM policy ALBIngressControllerIAMPolicy
# to alllow ALB makes API calls on your behalf
# Copy the Policy.Arn value
aws iam create-policy \
    --policy-name ALBIngressControllerIAMPolicy \
    --policy-document file://~/airflow-workplace/airflow-materials-aws/section-7/iam/iam-alb-policy.json

PolicyARN =arn:aws:iam::663161315447:policy/ALBIngressControllerIAMPolicy
# Create a service account and an IAM role for the pod running AWS ALB Ingress controller
eksctl create iamserviceaccount \
       --cluster=airflow \
       --namespace=kube-system \
       --name=alb-ingress-controller \
       --attach-policy-arn=$PolicyARN \
       --override-existing-serviceaccounts \
       --approve
       
# Deploy the AWS ALB Ingress controller
mkdir -p ~/airflow-workplace/airflow-eks-config/deployments
cp ~/airflow-workplace/airflow-materials-aws/section-7/deployments/airflow-alb-ingress-controller-dev.yml \
    ~/airflow-workplace/airflow-eks-config/deployments
    
cd airflow-eks-config
git add .
git commit -am "add ingress controller deployment"
git push

fluxctl sync --k8s-fwd-ns flux

kubectl get pods -n kube-system

# Add the service
cp ~/airflow-workplace/airflow-materials-aws/section-7/services/airflow-nodeport-dev.yml \
    ~/airflow-workplace/airflow-eks-config/services

# Add the ingress rule
mkdir -p ~/airflow-workplace/airflow-eks-config/ingresses
cp ~/airflow-workplace/airflow-materials-aws/section-7/ingresses/airflow-ingress-dev.yml ~/airflow-workplace/airflow-eks-config/ingresses

cd airflow-eks-config
git add .
git commit -am "add services and ingress rules"
git push
 
fluxctl sync --k8s-fwd-ns flux

# Check the ingress
kubectl get ingress
