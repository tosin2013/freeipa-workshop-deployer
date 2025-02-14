# FreeIPA Workshop Deployer

A comprehensive solution for deploying FreeIPA/Red Hat Identity Management Server across multiple infrastructure providers (AWS, DigitalOcean, kcli) using Terraform and Ansible.

## Supported Platforms

- RHEL 9.5 (Primary supported platform)
- Other RHEL/CentOS versions may work but are not officially supported

## Quick Start

### 1. Bootstrap the Environment

```bash
# Clone the repository
git clone https://github.com/yourusername/freeipa-workshop-deployer.git
cd freeipa-workshop-deployer

# Run bootstrap script (requires root/sudo)
sudo ./bootstrap.sh
```

The bootstrap script:
- Verifies RHEL 9.5
- Installs required packages
- Sets up Terraform
- Configures Python dependencies
- Sets up firewall rules
- Creates initial configuration

### 2. Validate the Environment

```bash
# Run validation script
sudo ./validate.sh
```

The validation script checks:
- RHEL 9.5 compatibility
- Required packages and tools
- Python dependencies
- Firewall configuration
- Infrastructure provider requirements

### 3. Quick Deployment

The `quick-deploy.sh` script provides a streamlined way to deploy and manage FreeIPA across different providers:

```bash
# Deploy using kcli
./quick-deploy.sh kcli deploy

# Deploy using AWS
AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=yyy ./quick-deploy.sh aws deploy

# Deploy using DigitalOcean
DO_PAT=xxx ./quick-deploy.sh do deploy

# Destroy deployment
./quick-deploy.sh [aws|do|kcli] destroy
```

#### Environment Variables for Customization

Common variables:
- DOMAIN: Custom domain name (default: example.com)
- DNS_FORWARDER: Custom DNS forwarder (default: 1.1.1.1)
- IDM_HOSTNAME: Custom IdM hostname (default: idm)

Provider-specific variables:
```bash
# AWS
AWS_REGION=us-east-2
AWS_VPC_ID=vpc-xxx

# DigitalOcean
DO_DATA_CENTER=nyc3
DO_VPC_CIDR=10.42.0.0/24
DO_NODE_IMAGE=centos-8-x64
DO_NODE_SIZE=s-1vcpu-2gb

# kcli
KCLI_NETWORK=qubinet
COMMUNITY_VERSION=false  # Set to true for CentOS
```

## Traditional Deployment Method

If you prefer the traditional deployment method:

1. Copy `example.vars.sh` to `vars.sh`
2. Configure your provider credentials and settings
3. Run `./total_deployer.sh`

## Connecting to OpenShift

1. Download the CA Cert from `/etc/ipa/ca.crt` or via the IPA Web Console at ***Authentication > Certificates > 1 > Actions > Download Certificate***
2. Configure a new OAuth Identity Provider with these settings:
    - email: mail
    - id: dn
    - name: cn
    - preferredUsername: uid
    - bindDN: 'uid=admin,cn=users,cn=accounts,dc=example,dc=com'
    - bindPassword: (your password)
    - ca: fromDownloadedFile
    - url: ldaps://idm.example.com:636/cn=users,cn=accounts,dc=example,dc=com?uid?sub?(uid=*)
    - name: LDAP

For YAML configuration example, see below:

```yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  annotations:
    release.openshift.io/create-only: 'true'
  name: cluster
spec:
  identityProviders:
    - ldap:
        attributes:
          email:
            - mail
          id:
            - dn
          name:
            - cn
          preferredUsername:
            - uid
        bindDN: 'uid=admin,cn=users,cn=accounts,dc=example,dc=com'
        bindPassword:
          name: ldap-bind-password
        ca:
          name: ldap-ca
        insecure: false
        url: >-
          ldaps://idm.example.com:636/cn=users,cn=accounts,dc=example,dc=com?uid?sub?(uid=*)
      mappingMethod: claim
      name: WorkshopLDAP
      type: LDAP
```

## DNS Management 

* [Dynamic DNS Script](docs/dns_profiles.md) for creating DNS entries for different profiles (OpenShift, Ansible Automation Platform, etc.)
* [Dynamic DNS](docs/dynamic_dns.md) Python script for managing DNS entries using YAML files

## Contributing

1. Fork the repository
2. Create your feature branch
3. Submit a pull request

## License

See LICENSE file for details.
