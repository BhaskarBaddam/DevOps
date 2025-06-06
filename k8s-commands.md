## K8S Basics
### Deployment advantages
1. Auto-Healing
2. Auto-Scaling
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
## K8S Service
### What if no service ?
When a pod restarts, because of auto-healing capability new pods is generated and it's IP will change. So, it is difficult to point client to pod IPs. 
### With Service
Service can as load balanacer to the pods. Instead of accessing pods, we can access service and it points the group of pods behind it.
Service will group the pods based on labels & selectors and not using pod IPs. This way it will eliminate dependency on IPs.
### Advantages of Service
1. Load Balancing
2. Service Discovery
3. Expose to External World
Selecting/grouping the pods based on labels & selectors is called **Service Discovery**. It keeps track of labels.
### Types of Service
1. Cluster IP
2. NodePort
3. Load Balancer
#### ClusterIP
It can be accessed only in k8s cluster. Only who has access to k8s cluster, can access this service.
#### NodePort
It allows application to access inside an organisation. It typically provides access to node IPs. Whoever has access to k8s nodes can access this service.
#### Load Balancer
It exposes application to external world. It is applicable to Cloud only. It creates an load balancer IP which can be exposed to external world. It uses Cloud-Control Manager to generate public load balancer IP in Cloud (AWS, Azure, GCP, etc.,). 
Anybody in the world can access this service.
### When to use which service
Generally we will use **ClusterIP** for databases because we don't them to expose externally and databases need to be accessible only to application tier.
We will use **NodePort** when we don't want to expose service to the world and should be accessible only within an VPC/organization.
We will use **Load Balancer** for mostly frontend applucations as these are need to accessible to the world/clients.
