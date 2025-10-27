terraform apply --auto-approve

kubectl apply -f 01/02/03...yaml


aws eks update-kubeconfig --region eu-west-3 --name eks_cluster_name

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
HEL

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace



