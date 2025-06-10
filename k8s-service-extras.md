### Understanding ClusterIP in NodePort Services
When you create a service of type NodePort, Kubernetes automatically assigns a ClusterIP to the service. This ClusterIP is used for internal communication within the cluster. The NodePort exposes the service on a static port across all nodes in the cluster, allowing external access.\
The ClusterIP assigned to a service is static and does not change over time, even if the service is of type NodePort
```
NAME                              TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
batch-service-java                NodePort   10.104.179.238   <none>        61000:61000/TCP   3d21h
emailsender-service-java          NodePort   10.111.76.243    <none>        61018:61018/TCP   12d
```
#### Accessing Services Internally
Internally, within the Kubernetes cluster, you can access the emailsender-service-java using its ClusterIP
```
http://10.111.76.243:61018
```
or using DNS name
```
http://emailsender-service-java.orfta-dev.svc.cluster.local:61018
```
#### Accessing Services Externally
Externally, you can access the service using any node's IP address and the assigned NodePort
```
http://<NodeIP>:61000
```
### DNS name for a service
In Kubernetes, each service is assigned a DNS name that follows this format:
```
<service-name>.<namespace>.svc.cluster.local
emailsender-service-java.orfta-dev.svc.cluster.local
```
This DNS name allows other pods within the same cluster to resolve and connect to the service.
### Test DNS Resolution
To test if the DNS name resolves correctly, you can use the nslookup command from within a pod in the same namespace:
```
kubectl run -i --tty --rm debug --image=busybox --restart=Never --namespace=orfta-dev -- nslookup emailsender-service-java.orfta-dev.svc.cluster.local
```
This command runs a temporary pod with the busybox image and performs an nslookup for the service's DNS name.
### To Log Into the Pod and check DNS
Inside the pod, use a DNS lookup tool like nslookup or dig to test the resolution of a service's DNS name.
```
kubectl exec -it <pod-name> -n <namespace-name> -- /bin/sh
nslookup emailsender-service-java.orfta-dev.svc.cluster.local
```
### To check CoreDNS Logs
```
kubectl logs -n kube-system -l k8s-app=kube-dns
```
Verify that the `/etc/resolv.conf` file inside the pod is correctly configured to use the cluster's DNS service.
