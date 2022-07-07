# Why we need MetalLb
# Create a deployement on default namespace
kubectl create deploy mywebsite --image nginx

# Check the status
kubectl get all

# Now create a service of Load balancer type
kubectl expose deploy mywebsite --port 80 --type LoadBalancer

# Check the status, this time the external IP of the service will be in pending state
kubectl get all

# So let us delete the service we created
kubectl delete svc mywebsite

# Now lets install MetalLb
# https://metallb.universe.tf/installation/
# Prerequisite
# Network block address

# Let us create the config file for our pool
vi metallb-pool.yaml

apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.18.2-192.168.18.100

# let us apply it
kubectl apply -f metallb-pool.yaml


# Now create the service again
kubectl expose deploy mywebsite --port 80 --type LoadBalancer
