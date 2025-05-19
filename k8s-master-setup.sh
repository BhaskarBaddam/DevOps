#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

########## STEP 1 ##########
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Swap OFF
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
########## END OF STEP 1 ##########

########## STEP 2 ##########
# Podman installation
sudo dnf install -y podman
podman --version
########## END OF STEP 2 ##########

########## STEP 3 ##########
# Load modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify that the br_netfilter, overlay modules are loaded
lsmod | grep br_netfilter
lsmod | grep overlay

# Verify that the sysctl variables are set to 1
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
########## END OF STEP 3 ##########

########## STEP 4 - To install CRI-O runtime ##########
sudo dnf install -y oraclelinux-release-el9

sudo tee -a /etc/dnf/dnf.conf <<EOF
proxy=<proxy>   #Enter proxy url here
EOF

cat <<EOF | tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF

sudo dnf install -y container-selinux
sudo dnf install -y cri-o

systemctl enable --now crio
systemctl status crio.service

##### Create CRI-O proxy configuration #####
mkdir -p /etc/systemd/system/crio.service.d/

cat <<EOF > /etc/systemd/system/crio.service.d/proxy.conf
[Service]
Environment="<proxyurl>"
Environment="<proxyurl>"
Environment="NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.0.0/16,"
EOF

systemctl daemon-reload
systemctl restart crio
########## END OF STEP 4 ##########

########## STEP 5 - K8S Installation ##########
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF

sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

kubeadm version
kubectl version --client
kubelet --version

##### Step 5.5 - Pull and tag Kubernetes images using Podman #####
# These steps are not necessary if the next step work without any issue
podman pull k8s.gcr.io/kube-apiserver:v1.32.3
podman pull k8s.gcr.io/kube-controller-manager:v1.32.3
podman pull k8s.gcr.io/kube-scheduler:v1.32.3
podman pull k8s.gcr.io/kube-proxy:v1.32.3
podman pull k8s.gcr.io/coredns/coredns:v1.11.3
podman pull k8s.gcr.io/pause:3.10
podman pull k8s.gcr.io/etcd:3.5.16-0

podman tag k8s.gcr.io/kube-apiserver:v1.32.3 registry.k8s.io/kube-apiserver:v1.32.3
podman tag k8s.gcr.io/kube-controller-manager:v1.32.3 registry.k8s.io/kube-controller-manager:v1.32.3
podman tag k8s.gcr.io/kube-scheduler:v1.32.3 registry.k8s.io/kube-scheduler:v1.32.3
podman tag k8s.gcr.io/kube-proxy:v1.32.3 registry.k8s.io/kube-proxy:v1.32.3
podman tag k8s.gcr.io/coredns/coredns:v1.11.3 registry.k8s.io/coredns/coredns:v1.11.3
podman tag k8s.gcr.io/pause:3.10 registry.k8s.io/pause:3.10
podman tag k8s.gcr.io/etcd:3.5.16-0 registry.k8s.io/etcd:3.5.16-0
########## END OF STEP 5 ##########

########## STEP 6 - Kubeadm init ##########
kubeadm init --control-plane-endpoint "<master-node-IP>:6443" --pod-network-cidr=192.168.0.0/16 --upload-certs --v=5
#Change 10.10.130.73 to contraol-plane IP
########## END OF STEP 6 ##########

########## STEP 7 ##########
export KUBECONFIG=/etc/kubernetes/admin.conf
export https_proxy=<proxyurl> && export http_proxy=<proxyurl>
########## END OF STEP 7 ##########

########## STEP 8 - Pod Network Installation ##########
cd /appl_logs/
sudo mkdir -p flannel
cd flannel
export https_proxy=<proxyurl> && export http_proxy=<proxyurl>
wget https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Replace default CIDR with custom CIDR
sed -i 's/10.244.0.0\/16/192.168.0.0\/16/' kube-flannel.yml

export KUBECONFIG=/etc/kubernetes/admin.conf
# Apply the Flannel network configuration
kubectl apply -f kube-flannel.yml
########## END OF STEP 8 ##########

#Add these cluster IPs
#Add all the cluster IPs and hostnames in /etc/hosts like below
<IP address>   <hostname>
<IP address>   <hostname>
<IP address>   <hostname>
<IP address>   <hostname>
