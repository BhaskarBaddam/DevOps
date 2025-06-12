## Calling shared libraries or other workflows

**`main.yml`** (caller workflow)
Need to use `uses:`
```
name: Main Workflow

on:
  workflow_dispatch:

jobs:
  call-test-workflow:
    uses: your-org/your-repo/.github/workflows/test.yml@main                # Calling other workflows
    with:
      environment: dev
    secrets:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```
**`test.yml`** (called/reusable workflow)
Need to use `workflow_call:` in sub-groocy like file.
```
name: Test Reusable Workflow

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      SONAR_TOKEN:
        required: true

jobs:
  echo-env:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Env is ${{ inputs.environment }}"
      - run: echo "Sonar token is ${{ secrets.SONAR_TOKEN }}"
```
