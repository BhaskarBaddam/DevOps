Callinh shared libraries or other workflows
```
name: Main Workflow

on:
  workflow_dispatch:

jobs:
  call-test-workflow:
    uses: your-org/your-repo/.github/workflows/test.yml@main #Calling other workflows
    with:
      environment: dev
    secrets:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```
