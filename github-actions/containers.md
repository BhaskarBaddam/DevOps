#### Using docker image to run a step
```
runs-on: self-hosted
container:
  image: your/image:tag
  options: --user root  # Optional: for permissions
```
Example
```
jobs:
  build:
    runs-on: self-hosted
    container:
      image: maven:3.9.4-eclipse-temurin-17
    steps:
      - uses: actions/checkout@v3

      - name: Build & Upload
        env:
          NEXUS_USERNAME: ${{ secrets.NEXUS_USERNAME }}
          NEXUS_PASSWORD: ${{ secrets.NEXUS_PASSWORD }}
        run: |
          mvn clean install
          mvn deploy -Dnexus.username=$NEXUS_USERNAME -Dnexus.password=$NEXUS_PASSWORD
```
