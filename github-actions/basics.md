## Github Actions
- Github actions is yet another CICD solution.
- This is a platform oriented soluion similar to Gitlab CI.
- No plugins need to be installed manually like in Jenkins.
- The plugins are auto-installed. Installed by default. We can directly use plugins.
- It follows yaml syntax

#### Action files
Create `.github/workflows` in root of the repository.
We can place any number of action files in `.github/workflows`

#### Comparision to Jenkins
- Here we have #Runners# similar to #Nodes# in jenkins.
- We can create self-hosted runners or use github hosted runners.

#### When to use Self-Hosted Runners ?
1. When we use prviate repository
2. When we require high capacity runners
3. When security is key

#### How to use Self-Hosted Runners ?
settings --> runners --> create self-hosted runners
Open respective ports for the server accordingly.
this is using github hosted runners.
```
jobs:
  deploy:
    runs-on: ubuntu-latest
```
this is using Self-Hosted Runners
```
jobs:
  deploy:
    runs-on: self-hosted
```

#### Secrets and Variables
