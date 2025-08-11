#!/bin/bash

minikube start \
  --driver=docker \
  --mount=true \
  --mount-string="$HOME/certs:/hostcerts"

minikube ssh -- bash -c "
  sudo cp /hostcerts/zscaler.crt /usr/local/share/ca-certificates/zscaler.crt &&
  sudo update-ca-certificates &&
  sudo systemctl restart docker"
