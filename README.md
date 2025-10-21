# Crossplane Setup
For a fast setup of crossplane in a minikube environment run `./setup.sh` while inside this project directory.
## Configure `provider-kubernetes`
```bash
SA=$(kubectl -n crossplane-system get sa -o name | grep provider-kubernetes | sed -e 's|serviceaccount\/|crossplane-system:|g')
kubectl create clusterrolebinding provider-kubernetes-admin-binding --clusterrole cluster-admin --serviceaccount="${SA}"
kubectl apply -f provider/config/config-provider-kubernetes.yaml
```
## Configure `provider-gitlab`
```bash
kubectl create secret generic gitlab-credentials -n crossplane-system --from-literal=token="<PERSONAL_ACCESS_TOKEN>"
kubectl apply -f provider/config/config-provider-gitlab.yaml
```
## Configure `provider-helm`
```bash
kubectl apply -f provider/config/config-provider-helm.yaml
```

