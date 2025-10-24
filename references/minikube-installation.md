# Minikube Installation Guide

Minikube is a tool that runs a single-node Kubernetes cluster locally on your computer. It's perfect for learning Kubernetes, development, and testing.

---

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation by Operating System](#installation-by-operating-system)
   - [Windows](#windows)
   - [macOS](#macos)
   - [Linux](#linux)
3. [Starting Minikube](#starting-minikube)
4. [Verification](#verification)
5. [Basic Configuration](#basic-configuration)
6. [Troubleshooting](#troubleshooting)
7. [Useful Commands](#useful-commands)

---

## System Requirements

### Minimum Requirements:
- **CPU:** 2 CPUs or more
- **Memory:** 2GB of free memory
- **Disk:** 20GB of free disk space
- **Internet connection**
- **Container or virtual machine manager** (Docker, Podman, VirtualBox, etc.)

### Supported Drivers:
- Docker (recommended)
- Podman
- VirtualBox
- VMware
- Hyper-V (Windows)
- KVM (Linux)

---

## Installation by Operating System

## Windows

### Prerequisites

**Option 1: Using Docker Desktop (Recommended)**

1. **Install Docker Desktop:**
   - Download from: https://www.docker.com/products/docker-desktop
   - Run the installer
   - Restart your computer
   - Start Docker Desktop

**Option 2: Using Hyper-V**

1. **Enable Hyper-V:**
   ```powershell
   # Run PowerShell as Administrator
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
   ```
   - Restart your computer

### Install kubectl

**Using Chocolatey:**
```powershell
choco install kubernetes-cli
```

**Using PowerShell (Manual):**
```powershell
# Download kubectl
curl.exe -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"

# Add to PATH
# Move kubectl.exe to C:\Program Files\kubectl\
# Add C:\Program Files\kubectl\ to your PATH environment variable
```

**Verify kubectl:**
```powershell
kubectl version --client
```

### Install Minikube

**Method 1: Using Chocolatey (Easiest)**
```powershell
choco install minikube
```

**Method 2: Using Windows Installer**
1. Download the installer: https://storage.googleapis.com/minikube/releases/latest/minikube-installer.exe
2. Run the installer
3. Follow the installation wizard

**Method 3: Manual Installation**
```powershell
# Download minikube
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

# Add to PATH
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
}
```

**Verify Installation:**
```powershell
minikube version
```

---

## macOS

### Prerequisites

**Install Homebrew (if not already installed):**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Install Docker Desktop (Recommended):**
```bash
brew install --cask docker
```
Or download from: https://www.docker.com/products/docker-desktop

### Install kubectl

```bash
brew install kubectl
```

**Verify:**
```bash
kubectl version --client
```

### Install Minikube

**Using Homebrew (Recommended):**
```bash
brew install minikube
```

**Manual Installation (Intel):**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm minikube-darwin-amd64
```

**Manual Installation (Apple Silicon/M1/M2):**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube
rm minikube-darwin-arm64
```

**Verify Installation:**
```bash
minikube version
```

---

## Linux

### Prerequisites

**Install Docker (Recommended):**

**Ubuntu/Debian:**
```bash
# Update package index
sudo apt-get update

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add your user to docker group
sudo usermod -aG docker $USER

# Apply new group membership (or logout and login)
newgrp docker
```

**Fedora/RHEL/CentOS:**
```bash
# Install Docker
sudo dnf install -y docker

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

**Arch Linux:**
```bash
sudo pacman -S docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

### Install kubectl

**Method 1: Using package manager**

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubectl
```

**Fedora/RHEL/CentOS:**
```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF

sudo dnf install -y kubectl
```

**Method 2: Binary download (All Linux)**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

**Verify:**
```bash
kubectl version --client
```

### Install Minikube

**Method 1: Binary download (Recommended)**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```

**Method 2: Using package manager**

**Debian/Ubuntu:**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
rm minikube_latest_amd64.deb
```

**Fedora/RHEL/CentOS:**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
rm minikube-latest.x86_64.rpm
```

**Verify Installation:**
```bash
minikube version
```

---

## Starting Minikube

### Basic Start

```bash
# Start with default settings (Docker driver)
minikube start

# This will:
# - Download Kubernetes components
# - Create a VM or container
# - Configure kubectl to use minikube
```

### Start with Specific Driver

**Using Docker:**
```bash
minikube start --driver=docker
```

**Using Podman:**
```bash
minikube start --driver=podman
```

**Using VirtualBox:**
```bash
minikube start --driver=virtualbox
```

**Using Hyper-V (Windows):**
```bash
minikube start --driver=hyperv
```

### Start with Custom Resources

```bash
# Specify CPU and memory
minikube start --cpus=4 --memory=8192

# Specify Kubernetes version
minikube start --kubernetes-version=v1.28.0

# Combine options
minikube start --driver=docker --cpus=4 --memory=8192 --disk-size=20g
```

### Set Default Driver (Optional)

```bash
# Set Docker as default driver
minikube config set driver docker

# Now you can just run
minikube start
```

---

## Verification

### Check Minikube Status

```bash
# Check if minikube is running
minikube status
```

**Expected output:**
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

### Check Cluster Info

```bash
# View cluster information
kubectl cluster-info

# Get nodes
kubectl get nodes

# Get all system pods
kubectl get pods -n kube-system
```

### Access Kubernetes Dashboard (Optional)

```bash
# Start the dashboard
minikube dashboard

# This will open the dashboard in your browser
```

---

## Basic Configuration

### Enable Addons

Minikube comes with useful addons:

```bash
# List available addons
minikube addons list

# Enable commonly used addons
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable dashboard

# Disable an addon
minikube addons disable dashboard
```

### Configure kubectl Auto-completion

**Bash:**
```bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc
```

**Zsh:**
```bash
echo 'source <(kubectl completion zsh)' >> ~/.zshrc
source ~/.zshrc
```

### Create Alias (Optional)

```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'alias k=kubectl' >> ~/.bashrc
source ~/.bashrc
```

---

## Troubleshooting

### Issue: Minikube won't start

**Check system resources:**
```bash
# View available resources
free -h  # Linux/macOS
systeminfo  # Windows
```

**Solution:** Start with lower resources:
```bash
minikube start --cpus=2 --memory=2048
```

### Issue: Driver issues

**Check available drivers:**
```bash
minikube start --help | grep driver
```

**Try a different driver:**
```bash
minikube delete  # Delete existing cluster
minikube start --driver=docker
```

### Issue: Docker not running

**Linux/macOS:**
```bash
# Check Docker status
docker ps

# Start Docker
sudo systemctl start docker  # Linux
open -a Docker  # macOS
```

**Windows:**
- Open Docker Desktop application
- Ensure it's running (system tray icon)

### Issue: Permission denied (Linux)

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login, or run:
newgrp docker

# Try starting minikube again
minikube start
```

### Issue: VPN/Proxy problems

```bash
# Set HTTP proxy
minikube start --docker-env HTTP_PROXY=http://proxy:8080 \
               --docker-env HTTPS_PROXY=https://proxy:8080 \
               --docker-env NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.0.0/16
```

### View Minikube Logs

```bash
# View logs
minikube logs

# View detailed logs
minikube logs --file=minikube.log
```

### Complete Reset

```bash
# Delete current cluster
minikube delete

# Delete all minikube data
minikube delete --all --purge

# Start fresh
minikube start
```

---

## Useful Commands

### Cluster Management

```bash
# Start cluster
minikube start

# Stop cluster (preserves data)
minikube stop

# Pause cluster (save resources)
minikube pause

# Unpause cluster
minikube unpause

# Delete cluster
minikube delete

# SSH into minikube VM
minikube ssh

# View minikube IP
minikube ip
```

### Docker Environment

```bash
# Configure shell to use minikube's Docker daemon
eval $(minikube docker-env)

# Now docker commands use minikube's Docker
docker ps

# Revert to your local Docker
eval $(minikube docker-env -u)
```

### Service Access

```bash
# Get URL for a service
minikube service <service-name>

# List all services with URLs
minikube service list

# Open service in browser
minikube service <service-name> --url
```

### Addons Management

```bash
# List addons
minikube addons list

# Enable addon
minikube addons enable <addon-name>

# Disable addon
minikube addons disable <addon-name>

# Common addons:
# - metrics-server (resource monitoring)
# - ingress (ingress controller)
# - dashboard (web UI)
# - storage-provisioner (dynamic volume provisioning)
```

### Multiple Clusters

```bash
# Create additional cluster
minikube start -p cluster2

# List all clusters
minikube profile list

# Switch between clusters
minikube profile cluster2

# Delete specific cluster
minikube delete -p cluster2
```

### Updates

```bash
# Update minikube
# On Linux/macOS
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# On Windows with Chocolatey
choco upgrade minikube

# On macOS with Homebrew
brew upgrade minikube
```

---

## Quick Start Guide

### Complete Setup in 5 Minutes

**1. Install (pick your OS):**

```bash
# macOS
brew install minikube kubectl

# Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Windows (PowerShell as Admin)
choco install minikube kubernetes-cli
```

**2. Start cluster:**

```bash
minikube start --cpus=2 --memory=4096
```

**3. Verify:**

```bash
kubectl get nodes
kubectl get pods -A
```

**4. Deploy test app:**

```bash
kubectl create deployment hello-minikube --image=nginx
kubectl expose deployment hello-minikube --type=NodePort --port=80
minikube service hello-minikube
```

**5. Clean up when done:**

```bash
kubectl delete deployment hello-minikube
kubectl delete service hello-minikube
minikube stop
```

---

## Additional Resources

### Official Documentation
- Minikube Docs: https://minikube.sigs.k8s.io/docs/
- kubectl Docs: https://kubernetes.io/docs/reference/kubectl/

### Tutorials
- Kubernetes Tutorials: https://kubernetes.io/docs/tutorials/
- Interactive Tutorial: https://kubernetes.io/docs/tutorials/kubernetes-basics/

### Community
- Kubernetes Slack: https://slack.k8s.io/
- Minikube GitHub: https://github.com/kubernetes/minikube

---

## Next Steps

After successfully installing Minikube:

1. **Complete the Kubernetes Basics Tutorial:**
   ```bash
   # Try the official tutorial
   kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
   ```

2. **Enable useful addons:**
   ```bash
   minikube addons enable metrics-server
   minikube addons enable dashboard
   ```

3. **Explore the Dashboard:**
   ```bash
   minikube dashboard
   ```

4. **Try deploying a multi-tier application**

5. **Learn about Services, Deployments, and ConfigMaps**

---

## Tips for Learning

- **Start small:** Deploy simple applications first
- **Use the dashboard:** Visual representation helps understanding
- **Read error messages:** They often tell you exactly what's wrong
- **Clean up regularly:** Delete resources you're not using
- **Experiment:** Minikube is safe for trying things out

---

**Happy Kubernetes learning with Minikube! 🚀**

## Troubleshooting Contact

If you encounter issues:
1. Check the [troubleshooting section](#troubleshooting)
2. View Minikube logs: `minikube logs`
3. Search GitHub issues: https://github.com/kubernetes/minikube/issues
4. Ask in Kubernetes Slack: https://slack.k8s.io/