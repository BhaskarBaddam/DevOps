### Before Ingress
Nginx, F5 are enterprise load balancers used for VMs earlier. Load balancng can be done based on ratio, path, domain, sticket session, whitelisting, blacklisting.\
With enterprise load balancing, we can use single LB for multiple microservices.\
### Problems with Service
1. Service provides simple round-robin load balancing. It doesnot include enterprise load balancing.
2. When we use service of type load balancer and if we have more microservices (say 100), we need to create more services and it creates more static IPs in Cloud platforms which leads to increase in cost.

## Ingress
To overcome problems like above, Ingress was created. To use ingress we also need Ingress Controller.\
Ingress            ---> created by users as a resource.\
Ingress Controller ---> created by Load Balancing companies. Users need to install this from github.

<img width="575" alt="image" src="https://github.com/user-attachments/assets/24b19a85-b92a-40e8-86b4-aaa1622b831d" />

If we install ingress controller only, an IP will be assigned to ingress resource. That can be used for domain mapping.
