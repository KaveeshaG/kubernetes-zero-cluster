#!/bin/bash

# Hello SLIIT - Cleanup Script
# This script removes all deployed resources

set -e

echo "🧹 Hello SLIIT - Cleanup Script"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Confirm deletion
read -p "Are you sure you want to delete the Hello SLIIT application? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

print_status "Deleting Kubernetes resources..."
kubectl delete -f kubernetes/deployment.yaml --ignore-not-found=true
kubectl delete -f kubernetes/service.yaml --ignore-not-found=true

print_status "Checking for LoadBalancer service..."
kubectl delete -f kubernetes/service-loadbalancer.yaml --ignore-not-found=true 2>/dev/null || true

# Verify deletion
print_status "Verifying deletion..."
REMAINING=$(kubectl get all -l app=kubernetes-zero-cluster 2>/dev/null | wc -l)

if [ "$REMAINING" -le 1 ]; then
    print_success "All resources deleted successfully!"
else
    print_warning "Some resources may still be terminating..."
    kubectl get all -l app=kubernetes-zero-cluster
fi

echo ""
print_success "Cleanup complete!"
echo ""
