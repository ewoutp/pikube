# Install Kubernetes on an OrangePI clusters

This repo is used to install Kubernetes on an OrangePI PC2 cluster.
The boards are running Armbian.

Download image from:

```plain
https://dl.armbian.com/orangepipc2/Ubuntu_xenial_next.7z
```

## Step 1: Prepare system

Login as root:

Initit script will:

- Ask you to change root password
- Ask you to create a user: `pi`
- Set hostname: `hostnamectl set-hostname yourHostName`

```bash
sudo usermod -aG sudo pi
echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/pi
sudo chmod 0440 /etc/sudoers.d/pi
sudo reboot
```

Login as `pi`:

```bash
mkdir -p /home/pi/.ssh
curl https://github.com/ewoutp.keys > /home/pi/.ssh/authorized_keys
chmod -R og-rwx /home/pi/.ssh

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y overlayroot
```

## Step 2: Install USB data disk

```bash
(
echo t  # Set type
echo 83 # Type linux
echo w  # Write & exit
) | sudo fdisk /dev/sda
sudo mkfs.ext4 -F /dev/sda1
sudo mkdir -p /mnt/data
echo "UUID=$(sudo blkid /dev/sda1 -s UUID -o value) /mnt/data ext4 defaults,noatime,nodiratime 0"  | sudo tee -a /etc/fstab
sudo mount -a
function moveToBind {
    src=$1
    dst=$2
    [ -d $src ] || mkdir $src
    sudo mkdir -p $(dirname $dst)
    sudo mv $src $dst
    sudo mkdir -p $src
    sudo mount -o bind $dst $src
    echo "${dst} ${src} none bind 0 0" | sudo tee -a /etc/fstab
}
moveToBind /var/log /mnt/data/var/log
moveToBind /var/lib/docker /mnt/data/var/lib/docker
```

## Step 3: Install docker

Clone this repo and cd into it.

```bash
./setup_docker.sh
```

## Step 4: Install Kubernetes tools

```bash
./setup_kubernetes_tools
```

## Step 5: Create Kubernetes cluster

on master:

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

## Step 6: Freeze filesystem

```bash
echo 'overlayroot="tmpfs:recurse=0"' | sudo tee /etc/overlayroot.conf
sudo reboot
```
