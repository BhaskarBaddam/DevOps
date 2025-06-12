## RBAC in K8S
Simple and Complicated
Related to Security
1. Service accounts/Users
2. Roles/Cluster Role
3. Role Binding/Cluster Role Binding

User Management is not done by k8s. It is given **Identity Providers**.\
Service Account is yaml file which users can create.\
**Role** is a yaml file where we define what permisssions can be given. It is similat to IAM policies in AWS.\
**Role Binding** is used to attach roles to users. It binds Roles to Users/Service accounts.
