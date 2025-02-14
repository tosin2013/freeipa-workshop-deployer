#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Exit on error
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}FreeIPA Workshop Deployer Bootstrap${NC}"
echo "======================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Check RHEL version
if [ -f /etc/redhat-release ]; then
    RHEL_VERSION=$(cat /etc/redhat-release | grep -oP '(?<=release )\d+\.\d+')
    MAJOR_VERSION=$(echo $RHEL_VERSION | cut -d. -f1)
    if [ "$MAJOR_VERSION" != "9" ]; then
        echo -e "${RED}This script requires RHEL 9.x${NC}"
        exit 1
    fi
else
    echo -e "${RED}This script requires RHEL${NC}"
    exit 1
fi

# Function to check and install packages
check_and_install() {
    if ! rpm -q $1 &> /dev/null; then
        echo -e "${YELLOW}Installing $1...${NC}"
        dnf install -y $1
    else
        echo -e "${GREEN}$1 is already installed${NC}"
    fi
}

# Update system packages
echo "Updating system packages..."
dnf update -y

# Install EPEL repository
echo "Installing EPEL repository..."
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y

# Install required packages
echo "Installing required packages..."
REQUIRED_PACKAGES=(
    git
    curl
    wget
    unzip
    python3
    python3-pip
    python3-devel
    gcc
    openssl-devel
    bind
    bind-utils
    firewalld
    ansible-core
)

for package in "${REQUIRED_PACKAGES[@]}"; do
    check_and_install $package
done

# Install Terraform
TERRAFORM_VERSION="0.13.4"
if ! command -v terraform &> /dev/null; then
    echo "Installing Terraform ${TERRAFORM_VERSION}..."
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    mv terraform /usr/local/bin/
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    echo -e "${GREEN}Terraform ${TERRAFORM_VERSION} installed successfully${NC}"
else
    echo -e "${GREEN}Terraform is already installed${NC}"
fi

# Install required Python packages
echo "Installing required Python packages..."
pip3 install --upgrade pip
sudo pip3 install dnspython netaddr

# Install required Ansible collections
echo "Installing required Ansible collections..."
/usr/local/bin/ansible-galaxy collection install ansible.posix
/usr/local/bin/ansible-galaxy collection install community.general


# Configure firewalld
echo "Configuring firewall..."
systemctl enable --now firewalld
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=freeipa-ldap
firewall-cmd --permanent --add-service=freeipa-ldaps
firewall-cmd --reload

# Create vars.sh from example if it doesn't exist
if [ ! -f vars.sh ] && [ -f example.vars.sh ]; then
    echo "Creating vars.sh from example..."
    cp example.vars.sh vars.sh
    echo -e "${YELLOW}Please edit vars.sh with your specific configuration${NC}"
fi

# Final checks
echo -e "\n${GREEN}Bootstrap Complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit vars.sh with your specific configuration"
echo "2. Run validate.sh to verify the environment"
echo "3. Run ./total_deployer.sh to deploy FreeIPA"

chmod +x bootstrap.sh

print_section "Installing kcli"
if ! command_exists kcli; then
    print_info "Installing kcli..."
    curl -s https://raw.githubusercontent.com/karmab/kcli/main/install.sh | bash
    if [ ! -f /home/lab-user/.vault ];
    then 
        bash -c "openssl rand -base64 32 > /home/lab-user/.vault && chmod 600 /home/lab-user/.vault"
    fi
    if [ $? -eq 0 ]; then
        print_status "kcli installed successfully" 0
    else
        print_status "Failed to install kcli" 1
        exit 1
    fi
else
    print_status "kcli is already installed" 0
fi
