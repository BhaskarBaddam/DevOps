## Deployment advantages
1. Auto-Healing\
2. Auto-Scaling\
3. Makes sure the actual number of pods matches with desired pods

### Deployment flow
Deployment ---> RepliaSet ---> Pod

### Lists all pods
```
kubectl get pods -A
```
### Provides all information about pods
```
kubectl get pods -o wide
```
### To watch the pods real time
```
kubectl get pods -w
```
