
To trigger the pipeline use `on:` option.\
To trigger manually, use like below
```
on:
  workflow_dispatch:  # Manual trigger
  schedule:           # Cron-based trigger
    - cron: '30 5 * * 1-5'  # Run at 5:30 AM UTC, Monday to Friday
  push:
    branches:
      - main  # Trigger workflow on push to main branch
```
Naming the job
```
jobs:
  build:
```
Selecting runner
```
runs-on: ubuntu-latest  # Run job on GitHub-hosted Ubuntu machine
```
To checkout code or to use inbuilt plugins we need to use `uses`
```
uses: actions/checkout@v3  # Checks out the code to runner
```
To checkout different repo code to the runner
```
- uses: actions/checkout@v3
  with:
    repository: another-org/another-repo
    token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```
To use multiple runners. By-default these jobs run in parallel.
```
jobs:
  build-linux:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build on Linux"

  build-windows:
    runs-on: windows-latest
    steps:
      - run: echo "Build on Windows"

  build-mac:
    runs-on: macos-latest
    steps:
      - run: echo "Build on macOS"
```
You can make jobs run in sequence by using `needs`:
```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - run: echo "Testing..."

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - run: echo "Deploying..."
```
| Feature                   | GitHub Actions Equivalent                        |
| ------------------------- | ------------------------------------------------ |
| Manual trigger            | `workflow_dispatch`                              |
| Scheduled trigger         | `schedule` with `cron:`                          |
| Repo checkout             | `actions/checkout@v3` (defaults to current repo) |
| Multi-runner / multi-node | Define multiple `jobs` with different `runs-on`  |
| Sequential jobs           | Use `needs:` to chain jobs                       |
