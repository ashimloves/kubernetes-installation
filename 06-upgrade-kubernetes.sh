#### Official Document for upgrading 1.24.x to 1.25.x, for any other versions the instructions should be similar #####
# https://v1-25.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/


# get information of all of the nodes
kubectl get nodes -o wide

# Upgrading control plane nodes (Debian/Ubintu based systems, for RedHat based systems please check the official documentation)
# ---------- Step 1 -------------
sudo apt update

# Since the system was not updated for a while you might encounter the below error
# Only if you get error like this for the Kubernetes repo
# Failed to fetch https://apt.kubernetes.io/dists/kubernetes-xenial/InRelease  
# The following signatures couldn't be verified because the public key is not available: NO_PUBKEY XXXXXXXXXXX
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# Edit the file: 
sudo vi /etc/apt/sources.list.d/kubernetes.list
# To below
deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main

sudo apt-cache madison kubeadm
# find the latest 1.25 version in the list
# it should look like 1.25.x-00, where x is the latest patch

# ---------- Step 2 ------------
## One control plane node at a time
# replace x in 1.25.x-00 with the latest patch version
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.25.7-00 && \
sudo apt-mark hold kubeadm

# ---------- Step 3 ------------
sudo kubeadm version

sudo kubeadm upgrade plan

# ---------- Step 4 ------------

# replace x with the patch version you picked for this upgrade
sudo kubeadm upgrade apply v1.25.7

# ---------- Step 4 alt ------------
# For the other control plane nodes (instead of "sudo kubeadm upgrade apply")
sudo kubeadm upgrade node

# ---------- Step 5 ------------
# replace <node-to-drain> with the name of your node you are draining
kubectl drain <node-to-drain> --ignore-daemonsets

# ---------- Step 6 ------------
# Upgrade kubelet and kubectl 
# replace x in 1.25.x-00 with the latest patch version
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.25.7-00 kubectl=1.25.7-00 && \
sudo apt-mark hold kubelet kubectl

# ---------- Step 7 ------------
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# ---------- Step 8 ------------
# replace <node-to-uncordon> with the name of your node
kubectl uncordon <node-to-uncordon>

##### End of control plane upgrade #######

## Upgrade worker nodes

# ---------- Step 1 ------------
# replace x in 1.25.x-00 with the latest patch version
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.25.7-00 && \
sudo apt-mark hold kubeadm

# ---------- Step 2 ------------
sudo kubeadm upgrade node

# ---------- Step 3 ------------
# replace <node-to-drain> with the name of your node you are draining
kubectl drain <node-to-drain> --ignore-daemonsets

# ---------- Step 4 ------------
# replace x in 1.25.x-00 with the latest patch version
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.25.7-00 kubectl=1.25.7-00 && \
sudo apt-mark hold kubelet kubectl

# ---------- Step 5 ------------
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# ---------- Step 6 ------------
# replace <node-to-uncordon> with the name of your node
kubectl uncordon <node-to-uncordon>

# ---------- Step 7 ------------
# Since our certificate got renewed, we need to get the new config file for the user
kubectl config view --raw

# or
cat /etc/kubernetes/admin.conf

# ---------- Final ------------
# Verify
kubectl get nodes -o wide
