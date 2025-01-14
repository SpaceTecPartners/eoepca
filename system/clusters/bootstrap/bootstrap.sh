#!/usr/bin/env bash

ORIG_DIR="$(pwd)"
cd "$(dirname "$0")"
BIN_DIR="$(pwd)"

trap "cd '${ORIG_DIR}'" EXIT

# Namespaces
kubectl create namespace common
kubectl create namespace demo
kubectl create namespace infra
kubectl create namespace proc
kubectl create namespace rm
kubectl create namespace test
kubectl create namespace um

# Sealed Secrets
if test -f "sealed-secrets-master.key"; then kubectl apply -f "sealed-secrets-master.key"; fi
helm repo add bitnami-sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm upgrade -i --version 2.1.8 --create-namespace --namespace infra eoepca-sealed-secrets bitnami-sealed-secrets/sealed-secrets

# Cert Manager
helm repo add jetstack https://charts.jetstack.io
helm upgrade -i --version v1.8.0 --create-namespace --namespace cert-manager --set installCRDs=true cert-manager jetstack/cert-manager
