# Certizen Documentation

Comprehensive technical documentation for the Certizen decentralized educational credentials platform.

## 📖 Documentation Structure

### Getting Started
- **[Setup Guide](setup.md)** - Complete installation and deployment instructions
- **[Quick Reference](QUICK_REFERENCE.md)** - Common commands and operations

### Configuration & Environment
- **[Environment Restructure](ENVIRONMENT_RESTRUCTURE.md)** - Environment configuration guide
- **[Restructure Complete](RESTRUCTURE_COMPLETE.md)** - Project restructure summary

### Technical Documentation
- **[Architecture](architecture.md)** - System design, components, and data flow
- **[DIDComm Protocol](didcomm-protocol.md)** - DIDComm v2 implementation details
- **[Trust Registry](trust-registry.md)** - Trust registry configuration and management
- **[Development Guide](development.md)** - Best practices, patterns, and coding standards
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

### Project Management
- **[Product Requirements](product-requirements.md)** - Project specifications and requirements
- **[Git Workflow](git-workflow.md)** - Version control and collaboration guidelines

### Historical Documentation
- **[Archive](archive/)** - Historical implementation notes and refactoring summaries

## 🏗️ System Overview

The Certizen platform consists of:

1. **Student Vault App** (Flutter Mobile) - Credential storage and management
2. **University Issuance Services** (Dart) - Credential issuance backends
3. **Verifier Portal** (Flutter Web) - Employer verification interface
4. **Governance Portal** (Flutter Web) - Trust registry administration
5. **Trust Registry API** (Rust) - Trust registry backend service

## 🔗 Component Documentation

- [Governance Portal](../governance-portal/README.md)
- [Student Vault App](../student-vault-app/README.md)
- [University Issuance Service](../university-issuance-service/README.md)
- [Verifier Portal](../verifier-portal/README.md)

## 🚀 Quick Links

- **Quick Start**: Run `make dev-up` to start the environment
- **Common Commands**: [Quick Reference](QUICK_REFERENCE.md)
- **Setup Guide**: [Setup Guide](setup.md)
- **Understand the System**: [Architecture](architecture.md)

## 📝 Contributing

See [Git Workflow](git-workflow.md) for version control guidelines and [Development Guide](development.md) for coding standards.

## 🔒 Security

See [SECURITY.md](../SECURITY.md) for security policies and reporting vulnerabilities.

## 📄 License

See [LICENSE](../LICENSE) and [NOTICE.txt](../NOTICE.txt) for licensing information.
