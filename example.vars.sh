#!/usr/bin/env bash

DO_PAT="someSecretLongThing"

TERRAFORM_INSTALL="false"
TERRAFORM_VERSION="0.13.4"

DOMAIN="example.com"
DNS_FORWARDER="1.1.1.1"
PRIVATE_IP="freeipa"
IDM_HOSTNAME="idm"

INFRA_PROVIDER="aws" # aws or digitalocean or kcli

AWS_VPC_ID="vpc-something"
AWS_REGION="us-east-2"

DO_DATA_CENTER="nyc3"
DO_VPC_CIDR="10.42.0.0/24"
DO_NODE_IMAGE="centos-8-x64"
DO_NODE_SIZE="s-1vcpu-2gb"

### KCLI variables
export ANSIBLE_SAFE_VERSION="0.0.7"
export INVENTORY=localhost
export ANSIBLE_VAULT_FILE="/opt/qubinode_navigator/inventories/$INVENTORY/group_vars/control/vault.yml"
export ANSIBLE_ALL_VARIABLES="/opt/qubinode_navigator/inventories/${INVENTORY}/group_vars/all.yml"
KCLI_CONFIG_DIR="${HOME}/.kcli"
KCLI_CONFIG_FILE="${KCLI_CONFIG_DIR}/profiles.yml"
PROFILES_FILE="kcli-profiles.yml"
KCLI_PLANS_PATH=/opt/kcli-pipelines
FREEIPA_REPO_LOC=/opt/freeipa-workshop-deployer
KCLI_NETWORK="qubinet"
# Use COMMUNI=TY_VERSION="true" for centos9stream
# Use COMMUNITY_VERSION="false" for rhel8
COMMUNITY_VERSION="false"


### DO NOT EDIT PAST THIS LINE

export TF_VAR_idm_hostname=$IDM_HOSTNAME
export TF_VAR_domain=$DOMAIN
export TF_VAR_vpc_id=$AWS_VPC_ID
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_do_datacenter=$DO_DATA_CENTER
export TF_VAR_do_vpc_cidr=$DO_VPC_CIDR
export TF_VAR_do_token=$DO_PAT
export TF_VAR_droplet_size=$DO_NODE_SIZE
export TF_VAR_droplet_image=$DO_NODE_IMAGE
