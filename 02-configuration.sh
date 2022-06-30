#########################################
# Only in master
#########################################
sudo kubeadm config images pull

vi kubeadm-config-iptables-mode.yaml

apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
networking:
  serviceSubnet: 10.11.0.0/16
  podSubnet: 10.10.0.0/16
  dnsDomain: cluster.local
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: iptables

### Only if you face issue with containerd
rm /etc/containerd/config.toml
systemctl restart containerd

sudo kubeadm init --config kubeadm-config-iptables-mode.yaml --dry-run

sudo kubeadm config migrate --old-config kubeadm-config-iptables-mode.yaml --new-config kubeadm-config-iptables-mode-new.yaml

sudo kubeadm init --config kubeadm-config-iptables-mode-new.yaml --dry-run

sudo kubeadm init --config kubeadm-config-iptables-mode-new.yaml

# kubeadm join from console in all worker nodes
# follow console instructions

## if you forget to copy the contents after kubeadm init command like I did xD, You might need to add sudo before the kubeadm join command in the worker nodes
sudo kubeadm token create --print-join-command


#########################################
# Only on worker nodes
#########################################
-sudo kubeadm join command from the terminal

########################################################################################################################
# Only in master or if you have copied cluster config file to your host machine and your host machine has kubectl binary
#########################################################################################################################
kubectl get nodes -o wide