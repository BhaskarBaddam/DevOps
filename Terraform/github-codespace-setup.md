### Codespace in Github
- 2cpu and 4gb ram
- Click on code --> codespace
- search with `> dev` in search bar and select first one
- search for `terraform` and select verified one
- search with `> dev` in search bar and select first one
- search for `aws cli` and select it.
- search for `rebuild` and select it.
- It takes some time to configure

Pre-requisite
- create/get acces key and secret key for IAM user from aws account.

In Codespace
- Run `aws configure`
- To verify run like `aws s3 ls`
- Run `terraform init` in terraform files folder
- Dry run `terraform plan`
- Create the resources - `terraform apply`
- To delete created resources - `terraform destroy`

- State file is like db for resources
