#!/bin/bash

# Exit on error
set -e

########## Step 1 ##########
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Swap OFF
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
########## END OF STEP 1 ##########

########## Step 2 ##########
# Podman installation
sudo dnf install -y podman
podman --version
########## END OF STEP 2 ##########

########## Step 3 ##########
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

# Verify sysctl settings
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
########## END OF STEP 3 ##########

########## Step 4 - CRI-O Installation ##########
sudo dnf install -y oraclelinux-release-el9

sudo tee -a /etc/dnf/dnf.conf <<EOF
proxy=<proxy>
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
Environment="<proxy>"
Environment="<proxy>"
Environment="NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.0.0/16"
EOF

systemctl daemon-reload
systemctl restart crio
########## END OF STEP 4 ##########

########## Step 5 - K8S Installation ##########
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF

sudo yum install -y kubelet kubeadm

kubeadm version
kubelet --version
########## END OF STEP 5 ##########

########## Step 6 ##########
export KUBECONFIG=/etc/kubernetes/admin.conf
export https_proxy=<proxy> && export http_proxy=<proxy>
########## END OF STEP 6 ##########

########## Step 7 - Join the Cluster ##########
#Add these cluster IPs
#Add all the cluster IPs and hostnames in /etc/hosts like below
<IP address>   <hostname>
<IP address>   <hostname>
<IP address>   <hostname>
<IP address>   <hostname>

export KUBECONFIG=/etc/kubernetes/admin.conf
echo "Use the kubeadm join command now"
########## END OF STEP 7 ##########
