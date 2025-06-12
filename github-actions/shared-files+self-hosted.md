Folder Structure
```
.github/
└── workflows/
    ├── main.yml         # Master pipeline
    ├── build.yml        # Reusable - Build stage
    ├── test.yml         # Reusable - Test stage
    └── deploy.yml       # Reusable - Deploy stage
```
main.yml (Top-Level Orchestrator)
```
name: CI/CD Pipeline

on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        required: true
        default: dev
        options:
          - dev
          - staging
          - prod
  schedule:
    - cron: '0 2 * * *'  # Every day 2:00 AM UTC

jobs:
  call-build:
    uses: ./.github/workflows/build.yml
    with:
      build_mode: 'release'

  call-test:
    needs: call-build
    uses: ./.github/workflows/test.yml
    with:
      test_level: 'full'

  call-deploy:
    needs: call-test
    uses: ./.github/workflows/deploy.yml
    with:
      environment: ${{ github.event.inputs.environment || 'dev' }}
    secrets:
      SSH_USER: ${{ secrets.SSH_USER }}
      SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```
build.yml (Reusable Build Job)
```
name: Reusable Build

on:
  workflow_call:
    inputs:
      build_mode:
        required: true
        type: string

jobs:
  build:
    runs-on: [self-hosted, linux]
    steps:
      - uses: actions/checkout@v3

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build with Maven
        run: mvn clean install -P${{ inputs.build_mode }}
```
test.yml (Reusable Test Job)
```
name: Reusable Test

on:
  workflow_call:
    inputs:
      test_level:
        required: true
        type: string

jobs:
  test:
    runs-on: [self-hosted, linux]
    steps:
      - uses: actions/checkout@v3

      - name: Run Unit Tests
        run: mvn test -Dtest.level=${{ inputs.test_level }}

      - name: SonarQube Scan
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          mvn sonar:sonar \
            -Dsonar.projectKey=my-app \
            -Dsonar.host.url=https://sonar.mycompany.com \
            -Dsonar.login=$SONAR_TOKEN
```
deploy.yml (Reusable Ansible-Based Deploy)
```
name: Reusable Deploy

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      SSH_USER:
        required: true
      SSH_PRIVATE_KEY:
        required: true

jobs:
  deploy:
    runs-on: [self-hosted, ansible]
    steps:
      - uses: actions/checkout@v3
        with:
          repository: my-org/infra-ansible
          token: ${{ secrets.GH_PAT }}
          path: ansible

      - name: Set up SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa

      - name: Install Ansible
        run: |
          sudo apt update && sudo apt install -y ansible

      - name: Deploy App
        working-directory: ansible
        env:
          ANSIBLE_HOST_KEY_CHECKING: false
        run: |
          ansible-playbook -i inventories/${{ inputs.environment }}/hosts.ini site.yml \
            --extra-vars "env=${{ inputs.environment }}" \
            --user ${{ secrets.SSH_USER }}
```
