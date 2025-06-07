<img width="500" alt="image" src="https://github.com/user-attachments/assets/6bbf0a02-5b7d-4e5d-9f57-f627caa60f61" />


## ConfigMap
- ConfigMap solves the problem of storing the data/information that can be used by the application.\
- It is used to store non-sensitive data.\
- This data is stored in etcd as objects.\
- These data can be used as environment variables for pods.
```
kubectl apply -f <configmap-name>
kubectl get configmap
kubectl get cm
kubectl describe cm <configmap-name>
```
- We can store variables as env variables or volumeMounts in pods.\
- But in production environments, when the value changes, it is recommended to use volumeMounts.\
- In volumeMounts, the variables are stored as files rather than env variables.

## Secrets
- Secrets also stores data similar to ConfigMap but it is used to store sensitive data/information.\
- Data is encrypted before storing data in etcd.\
- RBAC should be applied to secrets to avoid compromising with least privilege principle.
