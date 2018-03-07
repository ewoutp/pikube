# Install Kubernetes on an OrangePI clusters

This repo is used to install Kubernetes on an OrangePI PC2 cluster.
The boards are running Armbian.

## Step 1: Install SSH Agent sudo

```bash
sudo apt-get update
sudo apt-get install -y libpam-ssh-agent-auth
curl https://github.com/ewoutp.keys | sudo tee /etc/ssh/sudo_authorized_keys
```

```bash
sudo visudo
```

Insert:

```plain
Defaults env_keep += SSH_AUTH_SOCK`
```

```bash
sudo nano /etc/pam.d/sudo
```

Set to:

```plain
#%PAM-1.0

auth [success=2 default=ignore] pam_ssh_agent_auth.so file=/etc/ssh/sudo_authorized_keys
@include common-auth
@include common-account
@include common-session-noninteractive
```

## Step 1: Install docker

```bash
./setup_docker.sh
```