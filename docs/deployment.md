---
layout: page
title: Deployment Guide
permalink: /deployment/
---

# Deployment Guide

This guide covers both development and production deployment procedures for the FreeIPA Workshop Deployer.

## Development Deployment

### Prerequisites
- Development environment set up according to [Technical Setup](technical-setup.md)
- Access to chosen infrastructure provider (AWS/DigitalOcean/kcli)
- Proper DNS configuration

### Steps

1. **Bootstrap Environment**
   ```bash
   ./bootstrap.sh
   ```
   This sets up the development environment with required dependencies.

2. **Configure Variables**
   - Copy example configuration:
     ```bash
     cp example.vars.sh vars.sh
     ```
   - Edit `vars.sh` with your specific configuration

3. **Validate Environment**
   ```bash
   ./validate.sh
   ```
   Ensures all prerequisites are met.

4. **Choose Provider**
   Select your infrastructure provider:
   - AWS: Use `1_infra_aws/create.sh`
   - DigitalOcean: Use `1_infra_digitalocean/create.sh`
   - kcli: Use `1_kcli/create.sh`

5. **Deploy Infrastructure**
   ```bash
   # Example for AWS
   cd 1_infra_aws
   ./create.sh
   ```

6. **Configure FreeIPA**
   ```bash
   cd 2_ansible_config
   ./configure.sh
   ```

7. **Verify Installation**
   - Access FreeIPA web UI
   - Test user provisioning
   - Verify DNS configuration

### Development Notes
- Use smaller instance sizes for cost efficiency
- Test domains recommended for development
- Debug logging enabled by default
- Consider using local kcli deployment for testing

## Production Deployment

### Prerequisites
- RHEL 9.5 environment
- Production-grade infrastructure access
- DNS delegation configured
- Security audit completed

### Steps

1. **Environment Verification**
   - Confirm RHEL 9.5 compatibility
   - Verify network requirements
   - Check DNS delegation

2. **Production Configuration**
   ```bash
   # Configure with production settings
   ./bootstrap.sh --production
   ```

3. **Infrastructure Setup**
   - Configure production-grade instances
     - AWS: m5.xlarge recommended
     - Equivalent sizes for other providers
   - Set up proper networking and security groups

4. **DNS Configuration**
   - Configure DNS delegation
   - Set up DNS profiles
   - Verify record propagation

5. **High-Availability Setup**
   - Deploy redundant servers
   - Configure load balancing
   - Set up replication

6. **Security Configuration**
   - Configure firewall rules
   - Set up SSL certificates
   - Implement security policies

7. **Monitoring Setup**
   - Configure system monitoring
   - Set up alerting
   - Enable performance metrics

### Production Notes
- Use production-grade instance sizes
- Implement comprehensive backup strategy
- Configure proper security measures
- Set up monitoring and alerting

## Deployment Caveats

### Assumptions
- RHEL 9.5 is the primary supported platform
- Root/sudo access is available
- Internet connectivity for package installation
- DNS delegation is properly configured

### Known Limitations
- Other RHEL/CentOS versions not officially supported
- Cloud provider quotas may affect deployment
- DNS propagation may take time
- Certificate provisioning requires public DNS resolution

## Troubleshooting

### Common Issues
1. **DNS Issues**
   - Verify DNS delegation
   - Check record propagation
   - Validate DNS configuration

2. **Connectivity Problems**
   - Verify network configuration
   - Check security groups/firewall rules
   - Validate port accessibility

3. **Certificate Issues**
   - Verify DNS resolution
   - Check certificate configuration
   - Validate SSL setup

### Getting Help
- Check service logs
- Review deployment logs
- Consult documentation
- Examine system metrics

## Additional Resources
- [DNS Profiles Guide](dns_profiles.md)
- [Dynamic DNS Setup](dynamic_dns.md)
- [Testing Procedures](testing.md)
