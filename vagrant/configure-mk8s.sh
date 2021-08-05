#!/bin/bash
set -e

VAGRANT_HOME="/home/vagrant"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >> /dev/null && pwd)"

# Start up microk8s
microk8s.stop
microk8s.start
microk8s.status --wait-ready

# Set kubectl alias
snap alias microk8s.kubectl kubectl

# Add vagrant user to microk8s group, changes reflected in next login
usermod -aG microk8s vagrant

# Set ~/.kube/config for integration with Skaffold and Helm
mkdir -p $VAGRANT_HOME/.kube
microk8s.kubectl config view --raw > $VAGRANT_HOME/.kube/config
echo "KUBECONFIG=$VAGRANT_HOME/.kube/config" >> /etc/profile
chown -R vagrant $VAGRANT_HOME/.kube
chgrp -R vagrant $VAGRANT_HOME/.kube
chmod 755 $VAGRANT_HOME/.kube
chmod 600 $VAGRANT_HOME/.kube/config

# Enable addons
microk8s.enable dns
microk8s.enable rbac
microk8s.enable storage
microk8s.enable registry
microk8s.enable ingress

# Apply resources for depends-on role
pushd "$SCRIPT_DIR"/../kubernetes/setup >> /dev/null
microk8s.kubectl apply -f role.yaml
microk8s.kubectl apply -f rolebinding.yaml
microk8s.kubectl apply -f serviceaccount.yaml
popd >> /dev/null

# Configure Ingress Controller to expose services locally
pushd "$SCRIPT_DIR"/../kubernetes/setup/microk8s >> /dev/null
microk8s.kubectl apply -f ingress-tcp-configmap.yaml
microk8s.kubectl patch -n ingress daemonset nginx-ingress-microk8s-controller --patch \
    "$(cat ingress-daemonset-patch.yaml)"
popd >> /dev/null

# Restart microk8s
microk8s.stop
microk8s.start
microk8s.status --wait-ready

echo "microk8s has been configured"
