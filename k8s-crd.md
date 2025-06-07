## K8S Custom Resource
k8s containes native resources like deployment, pod, replicaset, secrets, configmap etc..,\
To create custom resources for some external applications/tools, k8s extends capabalities of it or APIs of k8s.\

To extend k8s capabilities, there are 3 resources:
1. Custom Resource Definition
2. Custom Resource
3. Custom Controller

**Custom Resource Definition (CRD)**: Defining a new type of API to k8s. It is wrtitten as yaml file. It is created by external applications/tools.\
**Custom Resource**: It is created by users. It is vlidated against CRD.\
**Custom Controller**: It is required to create and watch custom resources. Without a controller, the resources are of no use. This will be provided by external application/tools.\
It can be written in java, python, golang.
