#!/bin/bash -x

# update ubuntu repositories
echo "update ubuntu repositories"
sudo apt-get update

# install podman
echo "install podman"
sudo apt-get -y install podman

# install minikube
echo "install minikube"
sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube start

# create shortcuts for following commands
echo "create shortcuts"
echo 'alias kubectl="minikube kubectl --"' >> /home/ubuntu/.bashrc
echo 'alias kg="kubectl get"' >> /home/ubuntu/.bashrc
echo 'alias ka="kubectl apply"' >> /home/ubuntu/.bashrc
echo 'alias kd="kubectl describe"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

# install helm
echo "install helm"
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh

# install crossplane (version 1.20.0)
echo "install crossplane"
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane --version 1.20.0

# install crossplane-cli
sudo curl -sL "https://raw.githubusercontent.com/crossplane/crossplane/main/install.sh" | XP_VERSION=v1.20.0 sh
sudo mv crossplane /usr/local/bin

# install provider-kubernetes
echo "install provider-kubernetes"
minikube kubectl -- apply -f provider/provider-kubernetes.yaml

# install provider-gitlab
echo "install provider-gitlab"
minikube kubectl -- apply -f provider/provider-gitlab.yaml

# install provider-helm
echo "install provider-helm"
minikube kubectl -- apply -f provider/provider-helm.yaml

# create daily shutdown
echo "create crontab for daily shutdown of the server"
(crontab -l 2>/dev/null; echo "30 18 * * * poweroff") | sudo crontab -