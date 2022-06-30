
# -f option is to surpress the prompt and do a force reset, can be useful if you want to automate the process
sudo kubeadm reset -f

sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*


sudo iptables -F && sudo iptables -X
sudo iptables -t nat -F && sudo iptables -t nat -X
sudo iptables -t raw -F && sudo iptables -t raw -X
sudo iptables -t mangle -F && sudo iptables -t mangle -X

# Be sure to delete any file with name starting as "kube" before running the below command or run it from an empty directory
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get autoremove  
