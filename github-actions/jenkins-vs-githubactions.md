## Github actions and Jenkins comparision
GitHub Actions (ci.yml)
```
name: CI

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Run tests
      run: npm test
```
Equivalent Jenkinsfile
```
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Set up Node.js') {
      steps {
        // Usually you install using Node tool plugin or container
        sh 'nvm install 18'
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Run tests') {
      steps {
        sh 'npm test'
      }
    }
  }
}
```
Explanation
| GitHub                   | Jenkins                          | What it does                           |
| ------------------------ | -------------------------------- | -------------------------------------- |
| `jobs.build`             | `stage('...')` inside `pipeline` | A named part of the process.           |
| `steps`                  | `steps`                          | Run shell commands or actions.         |
| `run: npm install`       | `sh 'npm install'`               | Shell command to install dependencies. |
| `uses: actions/checkout` | `checkout scm`                   | Checks out source code.                |
| `uses: setup-node`       | Usually manual or via a plugin   | Installs/setup Node.js                 |
