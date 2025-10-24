# Hello SLIIT - Kubernetes Demo Application 🎓

A beautiful, containerized Node.js web application designed for Kubernetes workshops at SLIIT (Sri Lanka Institute of Information Technology).

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)

---

## 🌟 Features

- 🐳 **Containerized** - Docker-ready application
- ☸️ **Kubernetes Native** - Includes deployment manifests with health checks
- 🔄 **Load Balancing Demo** - Shows different pod hostnames
- 📊 **Real-time Info** - Displays pod hostname, timestamp, and version
- 🚀 **Production Ready** - Health checks, resource limits, and auto-healing

---

## 📂 Project Structure

```
kubernetes-zero-cluster/
├── server.js                          # Express server
├── package.json                       # Node.js dependencies
├── Dockerfile                         # Docker build instructions
├── .dockerignore                      # Files to exclude from Docker
├── public/
│   └── index.html                     # Beautiful frontend UI
├── kubernetes/
│   ├── deployment.yaml                # K8s Deployment + NodePort Service
│   └── service-loadbalancer.yaml      # Alternative LoadBalancer Service
└── README.md                          # This file
└── references/
│   ├── cheat-sheet.md                 # Kubernetes Cheat Sheet
│   └── minikube-installation.md           # Minikube Installation guide
```

---

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ (for local development)
- Docker (for containerization)
- Kubernetes cluster (K3s, Minikube, or cloud)
- kubectl configured

---

## 💻 Local Development

### 1. Install Dependencies

```bash
cd kubernetes-zero-cluster
npm install
```

### 2. Run Locally

```bash
npm start
```

Visit: http://localhost:3000

### 3. Development Mode (with auto-reload)

```bash
npm run dev
```

---

## 🐳 Docker Deployment

### Build the Docker Image

```bash
# Build the image
docker build -t kubernetes-zero-cluster:v1 .

# Verify the image
docker images | grep kubernetes-zero-cluster
```

### Run with Docker

```bash
# Run the container
docker run -d -p 3000:3000 --name kubernetes-zero-cluster kubernetes-zero-cluster:v1

# Check if running
docker ps

# View logs
docker logs kubernetes-zero-cluster

# Stop and remove
docker stop kubernetes-zero-cluster
docker rm kubernetes-zero-cluster
```

### Test the Application

```bash
# Test locally
curl http://localhost:3000

# Or open in browser
open http://localhost:3000
```

---

## ☸️ Kubernetes Deployment

### Option 1: Quick Deploy (All-in-One)

```bash
# Apply deployment and service
kubectl apply -f kubernetes/deployment.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services
```

### Option 2: Step-by-Step Deploy

#### Step 1: Build and Load Image (for K3s/Minikube)

**For Minikube:**
```bash
# Use Minikube's Docker daemon
eval $(minikube docker-env)

# Build image
docker build -t kubernetes-zero-cluster:v1 .

# Verify
docker images | grep kubernetes-zero-cluster
```

**For K3s:**
```bash
# Build image
docker build -t kubernetes-zero-cluster:v1 .

# Save and load into K3s
docker save kubernetes-zero-cluster:v1 | sudo k3s ctr images import -
```

#### Step 2: Deploy to Kubernetes

```bash
# Create deployment and service
kubectl apply -f kubernetes/deployment.yaml

# Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app=kubernetes-zero-cluster --timeout=60s
```

#### Step 3: Verify Deployment

```bash
# Check all resources
kubectl get all -l app=kubernetes-zero-cluster

# Check pod details
kubectl get pods -o wide

# Describe deployment
kubectl describe deployment kubernetes-zero-cluster

# Check service
kubectl describe service kubernetes-zero-cluster-service
```

---

## 🌐 Access the Application

### Using NodePort (Default)

```bash
# Get the NodePort
kubectl get service kubernetes-zero-cluster-service

# Get node IP
kubectl get nodes -o wide

# Access the application
# http://<NODE_IP>:30100
```

**For Minikube:**
```bash
# Get the URL directly
minikube service kubernetes-zero-cluster-service --url

# Or open in browser
minikube service kubernetes-zero-cluster-service
```

**For K3s:**
```bash
# Get your node's external IP
kubectl get nodes -o wide

# Access at: http://<EXTERNAL_IP>:30100
```

### Using LoadBalancer (Cloud/Oracle Cloud)

```bash
# Apply LoadBalancer service
kubectl apply -f kubernetes/service-loadbalancer.yaml

# Wait for external IP (may take 1-2 minutes)
kubectl get service kubernetes-zero-cluster-loadbalancer --watch

# Access using external IP
# http://<EXTERNAL_IP>
```

### Using Port Forward (Testing)

```bash
# Forward local port to service
kubectl port-forward service/kubernetes-zero-cluster-service 8080:80

# Access at: http://localhost:8080
```

---

## 🧪 Testing Load Balancing

### Method 1: Using the Web UI

1. Open the application in browser
2. Click "Test Load Balancing" button
3. Watch the hostname change as requests hit different pods

### Method 2: Using curl

```bash
# Get service URL
SERVICE_URL=$(minikube service kubernetes-zero-cluster-service --url)  # For Minikube
# OR
SERVICE_URL="http://<NODE_IP>:30100"  # For K3s

# Make multiple requests
for i in {1..10}; do
  curl -s $SERVICE_URL/api/info | grep -o '"hostname":"[^"]*"'
  sleep 1
done
```

You should see different hostnames, showing load balancing across pods!

---

## 📊 Scaling the Application

### Scale Up

```bash
# Scale to 5 replicas
kubectl scale deployment kubernetes-zero-cluster --replicas=5

# Watch pods being created
kubectl get pods -w
```

### Scale Down

```bash
# Scale to 2 replicas
kubectl scale deployment kubernetes-zero-cluster --replicas=2

# Watch pods being terminated
kubectl get pods -w
```

### Auto-scaling (Optional)

```bash
# Enable metrics-server first (if not already)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/v1/download/components.yaml

# Create horizontal pod autoscaler
kubectl autoscale deployment kubernetes-zero-cluster --cpu-percent=50 --min=2 --max=10

# Check autoscaler status
kubectl get hpa
```

---

## 🔄 Rolling Updates

### Update to a New Version

#### Step 1: Modify the Application

```bash
# Edit server.js and change version
# version: '1.0.0' → version: '2.0.0'
```

#### Step 2: Rebuild Image

```bash
# Build new version
docker build -t kubernetes-zero-cluster:v2 .

# For Minikube
eval $(minikube docker-env)
docker build -t kubernetes-zero-cluster:v2 .

# For K3s
docker save kubernetes-zero-cluster:v2 | sudo k3s ctr images import -
```

#### Step 3: Update Deployment

```bash
# Update image
kubectl set image deployment/kubernetes-zero-cluster kubernetes-zero-cluster=kubernetes-zero-cluster:v2

# Watch rollout
kubectl rollout status deployment/kubernetes-zero-cluster

# Check rollout history
kubectl rollout history deployment/kubernetes-zero-cluster
```

### Rollback

```bash
# Rollback to previous version
kubectl rollout undo deployment/kubernetes-zero-cluster

# Rollback to specific revision
kubectl rollout undo deployment/kubernetes-zero-cluster --to-revision=1

# Check status
kubectl rollout status deployment/kubernetes-zero-cluster
```

---

## 🔍 Debugging

### View Logs

```bash
# Get all pod names
kubectl get pods -l app=kubernetes-zero-cluster

# View logs from a specific pod
kubectl logs <POD_NAME>

# Follow logs in real-time
kubectl logs -f <POD_NAME>

# View logs from all pods
kubectl logs -l app=kubernetes-zero-cluster --all-containers=true
```

### Execute Commands in Pod

```bash
# Get shell access
kubectl exec -it <POD_NAME> -- /bin/sh

# Run a command
kubectl exec <POD_NAME> -- node -v
kubectl exec <POD_NAME> -- cat /app/package.json
```

### Check Events

```bash
# View recent events
kubectl get events --sort-by=.metadata.creationTimestamp

# Watch events
kubectl get events -w
```

### Describe Resources

```bash
# Describe deployment
kubectl describe deployment kubernetes-zero-cluster

# Describe pod
kubectl describe pod <POD_NAME>

# Describe service
kubectl describe service kubernetes-zero-cluster-service
```

---

## 🧹 Cleanup

### Delete Kubernetes Resources

```bash
# Delete all resources
kubectl delete -f kubernetes/deployment.yaml

# Or delete individually
kubectl delete deployment kubernetes-zero-cluster
kubectl delete service kubernetes-zero-cluster-service

# Verify deletion
kubectl get all -l app=kubernetes-zero-cluster
```

### Remove Docker Image

```bash
# Remove image
docker rmi kubernetes-zero-cluster:v1

# For Minikube
eval $(minikube docker-env)
docker rmi kubernetes-zero-cluster:v1
```

---

## 🎓 Workshop Integration

### Perfect for Demonstrating:

1. **Containerization**
   - Building Docker images
   - Understanding Dockerfiles
   - Container best practices

2. **Kubernetes Deployments**
   - Creating deployments
   - Managing replicas
   - Resource limits

3. **Services & Networking**
   - ClusterIP, NodePort, LoadBalancer
   - Service discovery
   - Load balancing

4. **Health Checks**
   - Liveness probes
   - Readiness probes
   - Self-healing

5. **Scaling**
   - Manual scaling
   - Horizontal scaling
   - Load distribution

6. **Rolling Updates**
   - Zero-downtime updates
   - Rollback capabilities
   - Version management

---

## 🎯 Learning Exercises

### Exercise 1: Basic Deployment
Deploy the application and access it via NodePort

### Exercise 2: Scaling
Scale from 3 to 5 replicas and observe load balancing

### Exercise 3: Updates
Update the version and perform a rolling update

### Exercise 4: Rollback
Rollback to the previous version

### Exercise 5: Troubleshooting
Intentionally break something and practice debugging

---

## 📝 Configuration Details

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 3000 | Application port |

### Resource Limits

| Resource | Request | Limit |
|----------|---------|-------|
| CPU | 100m | 200m |
| Memory | 64Mi | 128Mi |

### Health Check Endpoints

| Endpoint | Purpose | Response |
|----------|---------|----------|
| `/health` | Health check | `{"status": "healthy"}` |
| `/api/info` | App info | Pod details JSON |

---

## 🐛 Common Issues

### Issue 1: ImagePullBackOff

**Problem:** Kubernetes can't find the image

**Solution for Minikube:**
```bash
eval $(minikube docker-env)
docker build -t kubernetes-zero-cluster:v1 .
```

**Solution for K3s:**
```bash
docker save kubernetes-zero-cluster:v1 | sudo k3s ctr images import -
```

### Issue 2: CrashLoopBackOff

**Problem:** Container keeps crashing

**Check logs:**
```bash
kubectl logs <POD_NAME>
kubectl describe pod <POD_NAME>
```

### Issue 3: Can't Access NodePort

**For Oracle Cloud:**
1. Check security list allows port 30100
2. Check node firewall: `sudo firewall-cmd --list-all`
3. Add rule if needed: `sudo firewall-cmd --add-port=30100/tcp --permanent`

**For Minikube:**
```bash
# Use minikube service instead
minikube service kubernetes-zero-cluster-service
```

---

## 🔗 Useful Commands Quick Reference

```bash
# Build
docker build -t kubernetes-zero-cluster:v1 .

# Deploy
kubectl apply -f kubernetes/deployment.yaml

# Status
kubectl get all -l app=kubernetes-zero-cluster

# Scale
kubectl scale deployment kubernetes-zero-cluster --replicas=5

# Update
kubectl set image deployment/kubernetes-zero-cluster kubernetes-zero-cluster=kubernetes-zero-cluster:v2

# Rollback
kubectl rollout undo deployment/kubernetes-zero-cluster

# Logs
kubectl logs -l app=kubernetes-zero-cluster --all-containers=true -f

# Access (Minikube)
minikube service kubernetes-zero-cluster-service

# Delete
kubectl delete -f kubernetes/deployment.yaml
```

---

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Node.js Documentation](https://nodejs.org/docs/)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)

---

## 🎉 Credits

Created for the **Hello Kubernetes! - Zero to Cluster** workshop at SLIIT (Sri Lanka Institute of Information Technology).

---

## 📄 License

MIT License - Feel free to use this for educational purposes!

---

**Happy Learning! 🚀🎓**
