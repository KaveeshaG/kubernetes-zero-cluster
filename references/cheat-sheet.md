# Kubernetes Quick Reference Cheat Sheet

## Essential kubectl Commands

### Cluster Information
```bash
kubectl cluster-info                 # Display cluster info
kubectl get nodes                    # List all nodes
kubectl version                      # Show kubectl and cluster version
```

### Working with Pods
```bash
kubectl get pods                     # List pods in current namespace
kubectl get pods -A                  # List pods in all namespaces
kubectl get pods -o wide             # List pods with more details
kubectl describe pod <POD_NAME>      # Detailed pod information
kubectl logs <POD_NAME>              # View pod logs
kubectl logs -f <POD_NAME>           # Follow pod logs
kubectl exec -it <POD_NAME> -- bash  # Execute command in pod
kubectl delete pod <POD_NAME>        # Delete a pod
```

### Working with Deployments
```bash
kubectl create deployment <NAME> --image=<IMAGE>              # Create deployment
kubectl get deployments                                        # List deployments
kubectl describe deployment <NAME>                             # Deployment details
kubectl scale deployment <NAME> --replicas=<NUMBER>            # Scale deployment
kubectl set image deployment/<NAME> <CONTAINER>=<NEW_IMAGE>   # Update image
kubectl delete deployment <NAME>                               # Delete deployment
```

### Working with Services
```bash
kubectl expose deployment <NAME> --port=<PORT> --type=NodePort   # Expose deployment
kubectl get services                                              # List services
kubectl get svc                                                   # List services (short)
kubectl describe service <NAME>                                   # Service details
kubectl delete service <NAME>                                     # Delete service
```

### Rollouts
```bash
kubectl rollout status deployment/<NAME>          # Check rollout status
kubectl rollout history deployment/<NAME>         # View rollout history
kubectl rollout undo deployment/<NAME>            # Rollback to previous version
kubectl rollout restart deployment/<NAME>         # Restart deployment
```

### Working with YAML Files
```bash
kubectl apply -f <FILE.yaml>                # Create/update resources from file
kubectl delete -f <FILE.yaml>               # Delete resources from file
kubectl get <RESOURCE> -o yaml              # Export resource as YAML
kubectl get deployment <NAME> -o yaml > file.yaml   # Save to file
```

### Debugging & Troubleshooting
```bash
kubectl get events                          # List cluster events
kubectl get events --sort-by=.metadata.creationTimestamp   # Sorted events
kubectl describe pod <POD_NAME>             # Check pod issues
kubectl logs <POD_NAME> --previous          # Logs from previous container
kubectl top nodes                           # Node resource usage
kubectl top pods                            # Pod resource usage
```

### Namespace Operations
```bash
kubectl get namespaces                      # List all namespaces
kubectl get pods -n <NAMESPACE>             # List pods in namespace
kubectl create namespace <NAME>             # Create namespace
kubectl delete namespace <NAME>             # Delete namespace
kubectl config set-context --current --namespace=<NAME>   # Set default namespace
```

---

## Common Resource Types

| Short Name | Full Name           | Description                        |
|------------|---------------------|------------------------------------|
| po         | pods                | Application containers             |
| deploy     | deployments         | Manages pod replicas               |
| svc        | services            | Network access to pods             |
| rs         | replicasets         | Maintains pod replicas             |
| ns         | namespaces          | Virtual clusters                   |
| cm         | configmaps          | Configuration data                 |
| secret     | secrets             | Sensitive data                     |
| ing        | ingresses           | HTTP/HTTPS routing                 |
| pv         | persistentvolumes   | Cluster storage                    |
| pvc        | persistentvolumeclaims | Storage requests                |

---

## Service Types

| Type           | Description                                      |
|----------------|--------------------------------------------------|
| ClusterIP      | Internal cluster access only (default)           |
| NodePort       | Exposes service on each node's IP at static port |
| LoadBalancer   | Cloud provider's external load balancer          |
| ExternalName   | Maps service to external DNS name                |

---

## Pod Lifecycle Phases

| Phase      | Description                                      |
|------------|--------------------------------------------------|
| Pending    | Pod accepted but not yet running                 |
| Running    | Pod bound to node, containers running            |
| Succeeded  | All containers terminated successfully           |
| Failed     | All containers terminated, at least one failed   |
| Unknown    | Pod state cannot be determined                   |

---

## Basic YAML Structure

### Deployment Template
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Service Template
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

---

## Useful Output Formats

```bash
kubectl get pods -o wide              # More columns
kubectl get pods -o yaml              # YAML format
kubectl get pods -o json              # JSON format
kubectl get pods -o name              # Just resource names
kubectl get pods --show-labels        # Show all labels
kubectl get pods -l app=myapp         # Filter by label
```

---

## Quick Tips

1. **Use Tab Completion**: Install kubectl bash completion for faster typing
   ```bash
   source <(kubectl completion bash)
   ```

2. **Alias kubectl**: Save typing by creating an alias
   ```bash
   alias k=kubectl
   ```

3. **Watch Resources**: Use `-w` flag to watch resources in real-time
   ```bash
   kubectl get pods -w
   ```

4. **Multiple Resources**: Get multiple resource types at once
   ```bash
   kubectl get pods,services,deployments
   ```

5. **Dry Run**: Test commands without applying
   ```bash
   kubectl create deployment test --image=nginx --dry-run=client -o yaml
   ```

---

## Remember

- **Declarative > Imperative**: Use YAML files for production
- **Label Everything**: Labels help organize and select resources
- **Use Namespaces**: Separate environments and teams
- **Monitor Resources**: Regularly check cluster health
- **Read the Docs**: https://kubernetes.io/docs/
