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
