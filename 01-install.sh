#########################################
# On master and worker nodes both
#########################################

#pre processing

## this will disable swap temporarily, will not presist after a reboot
sudo swapoff -a

## add a hash here before the swap or swap file if present and do a reboot
vi /etc/fstab


# Official docker installation guide :: https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc

# Make a directory to keep the keys (it will do nothing if the directory is already present)
sudo mkdir -p /etc/apt/keyrings

# Get Docker gpg key for ubuntu
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Add the repo for docker in ubuntu
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Official Kubernetes installation guide ::  https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


#install
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker run hello-world

sudo groupadd docker

sudo usermod -aG docker $USER

sudo apt-get install -y kubelet kubeadm kubectl
# important, so that apt doesn't do an auto upgrade to these packages as newer version maybe incompatible with currect configuration
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable docker.service

sudo systemctl enable containerd.service
