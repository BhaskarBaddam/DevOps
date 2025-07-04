#### Basics
- We can install Kubernetes in AWS in 2 ways
  1. in EC2 Instances
  2. Use EKS
#### EKS Intro
- AWS managed Kubernetes service.
- AWS managed Control Plane service.
- AWS manages only control plane with high availability. We need to attach worker nodes/data planes.
- We can select worker nodes as
  1. EC2 Instances : We need to setup for HA.
  2. Fargate - AWS serverless computes : HA automaticakky setup
- Robust & Highly stable EKS can be built
