#!/bin/bash

# Install argocd
kustomize build --enable-helm --enable-alpha-plugins --load-restrictor=LoadRestrictionsNone ../../resources/addons/argocd/. \
| kubectl apply -f -
# Wait for argocd to be ready
echo "Waiting for argocd to be ready..."

while true; do
  STATUS=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server \
  -o jsonpath='{.items[0].status.phase}')
  if [ "$STATUS" == "Running" ]; then
    echo "ArgoCD server pod ready"
    break
  fi
  echo "Current Status: $STATUS. Waiting..."
  sleep 5
done
# Get argocd admin password
echo 
echo "Getting ArgoCD admin password..."
ADMIN_PW=$(kubectl get secret argocd-initial-admin-secret -n argocd \
-o jsonpath="{.data.password}" | base64 -d)
echo "=========================="
echo "ArgoCD Admin Password: $ADMIN_PW"
echo "=========================="
echo "You can now access your argocd by port-forwarding the service ..."
echo " kubectl port-forward service/argocd-server -n argocd 8080:80"

# Install all apps and addons and making argocd manage itself
kustomize build --enable-helm --enable-alpha-plugins --load-restrictor=LoadRestrictionsNone . \
| kubectl apply -f -