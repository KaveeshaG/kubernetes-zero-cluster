#!/bin/bash

# Hello SLIIT - Quick Deployment Script
# This script automates the deployment process for the workshop

set -e

echo "🎓 Hello SLIIT - Kubernetes Deployment Script"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

print_success "kubectl is installed"

# Check if we're using Minikube or K3s
if command -v minikube &> /dev/null && minikube status &> /dev/null; then
    PLATFORM="minikube"
    print_status "Detected Minikube"
elif command -v k3s &> /dev/null; then
    PLATFORM="k3s"
    print_status "Detected K3s"
else
    PLATFORM="other"
    print_status "Using standard Kubernetes"
fi

# Build Docker image
print_status "Building Docker image..."
if [ "$PLATFORM" == "minikube" ]; then
    eval $(minikube docker-env)
    docker build -t kubernetes-zero-cluster:v1 .
elif [ "$PLATFORM" == "k3s" ]; then
    docker build -t kubernetes-zero-cluster:v1 .
    print_status "Importing image to K3s..."
    docker save kubernetes-zero-cluster:v1 | sudo k3s ctr images import -
else
    docker build -t kubernetes-zero-cluster:v1 .
fi

print_success "Docker image built successfully"

# Deploy to Kubernetes
print_status "Deploying to Kubernetes..."
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/service-loadbalancer.yaml

# Wait for deployment
print_status "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=kubernetes-zero-cluster --timeout=60s

print_success "Application deployed successfully!"

# Get service info
echo ""
echo "=============================================="
echo "📊 Deployment Status"
echo "=============================================="
kubectl get deployment kubernetes-zero-cluster
echo ""
kubectl get pods -l app=kubernetes-zero-cluster
echo ""
kubectl get service kubernetes-zero-cluster-service

# Show access information
echo ""
echo "=============================================="
echo "🌐 Access Information"
echo "=============================================="

if [ "$PLATFORM" == "minikube" ]; then
    print_status "Getting Minikube service URL..."
    URL=$(minikube service kubernetes-zero-cluster-service --url)
    echo ""
    print_success "Application URL: $URL"
    echo ""
    print_status "Opening application in browser..."
    minikube service kubernetes-zero-cluster-service
elif [ "$PLATFORM" == "k3s" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    if [ -z "$NODE_IP" ]; then
        NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
    fi
    NODE_PORT=$(kubectl get service kubernetes-zero-cluster-service -o jsonpath='{.spec.ports[0].nodePort}')
    echo ""
    print_success "Application URL: http://${NODE_IP}:${NODE_PORT}"
    echo ""
    print_warning "Make sure port ${NODE_PORT} is open in your firewall!"
else
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
    NODE_PORT=$(kubectl get service kubernetes-zero-cluster-service -o jsonpath='{.spec.ports[0].nodePort}')
    echo ""
    print_success "Application URL: http://${NODE_IP}:${NODE_PORT}"
fi

echo ""
echo "=============================================="
echo "🎉 Deployment Complete!"
echo "=============================================="
echo ""
print_status "Useful commands:"
echo "  - Check pods:    kubectl get pods -l app=kubernetes-zero-cluster"
echo "  - View logs:     kubectl logs -l app=kubernetes-zero-cluster"
echo "  - Scale app:     kubectl scale deployment kubernetes-zero-cluster --replicas=5"
echo "  - Delete app:    kubectl delete -f kubernetes/deployment.yaml"
echo ""
