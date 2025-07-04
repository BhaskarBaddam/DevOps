#### Basics
- We can install Kubernetes in AWS in 2 ways
  1. Use **EC2 Instances** to setup K8S
  2. Use **EKS**
  3. 
#### EKS Intro
- AWS managed Kubernetes service.
- AWS managed Control Plane service.
- AWS manages only control plane with high availability. We need to attach worker nodes/data planes.
- We can select worker nodes as
  1. EC2 Instances : We need to setup for HA.
  2. Fargate (AWS serverless compute): HA automatically setup.
- Robust & Highly stable EKS can be built
  
#### Ingress
- Ingress & Ingress Controllers are used for loadbalancing purpose.
- Expose the application to users/outside.

#### EKS Setup
1. EKS can be created from AWS console
2. It can also be created from local using kubectl, eksctl, awscli by configuring aws `aws configure` (Suggested)
   - When we create EKS using CLI, in backend CloudFormation templates will be created for cluster 

Use this link for hands-on - https://github.com/iam-veeramalla/aws-devops-zero-to-hero/blob/main/day-22/README.md
