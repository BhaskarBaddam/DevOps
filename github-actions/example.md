### 📁 .github/workflows/main.yml
```
name: Full CI/CD Pipeline

on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        required: true
        options: [dev, staging, prod]
        default: dev
  schedule:
    - cron: '0 2 * * *'  # Run daily at 2 AM UTC

jobs:
  build:
    uses: ./.github/workflows/build.yml
    with:
      build_mode: release

  test:
    needs: build
    uses: ./.github/workflows/test.yml

  deploy:
    needs: test
    uses: ./.github/workflows/deploy.yml
    with:
      environment: ${{ github.event.inputs.environment || 'dev' }}
    secrets:
      SSH_USER: ${{ secrets.SSH_USER }}
      SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
      GH_PAT: ${{ secrets.GH_PAT }}
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      NEXUS_USERNAME: ${{ secrets.NEXUS_USERNAME }}
      NEXUS_PASSWORD: ${{ secrets.NEXUS_PASSWORD }}
```

### 📁 .github/workflows/build.yml
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
    env:
      JAVA_VERSION: '17'
      APP_NAME: 'myapp'

    steps:
      - uses: actions/checkout@v3

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          java-version: ${{ env.JAVA_VERSION }}
          distribution: temurin

      - name: Build
        run: mvn clean install -P${{ inputs.build_mode }}

      - name: Upload to Nexus
        env:
          NEXUS_USERNAME: ${{ secrets.NEXUS_USERNAME }}
          NEXUS_PASSWORD: ${{ secrets.NEXUS_PASSWORD }}
        run: |
          mvn deploy -Dnexus.username=$NEXUS_USERNAME -Dnexus.password=$NEXUS_PASSWORD
```

### 📁 .github/workflows/test.yml
```
name: Reusable Test

on:
  workflow_call:

jobs:
  test:
    runs-on: [self-hosted, linux]

    steps:
      - uses: actions/checkout@v3

      - name: Unit Tests
        run: mvn test

      - name: SonarQube Scan
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          mvn sonar:sonar \
            -Dsonar.projectKey=myapp \
            -Dsonar.host.url=https://sonar.mycompany.com \
            -Dsonar.login=$SONAR_TOKEN
```

### 📁 .github/workflows/deploy.yml
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
      GH_PAT:
        required: true
      SONAR_TOKEN:
        required: true
      NEXUS_USERNAME:
        required: true
      NEXUS_PASSWORD:
        required: true

jobs:
  deploy:
    runs-on: [self-hosted, ansible]
    env:
      ANSIBLE_HOST_KEY_CHECKING: false

    steps:
      - name: Checkout Ansible Repo
        uses: actions/checkout@v3
        with:
          repository: my-org/ansible-repo
          token: ${{ secrets.GH_PAT }}
          path: ansible

      - name: Setup SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa

      - name: Install Ansible
        run: sudo apt update && sudo apt install -y ansible

      - name: Run Ansible Playbook
        working-directory: ansible
        run: |
          ansible-playbook -i inventories/${{ inputs.environment }}/hosts.ini site.yml \
            --user ${{ secrets.SSH_USER }} \
            --extra-vars "env=${{ inputs.environment }}"
```
