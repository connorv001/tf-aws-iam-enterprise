# Platform Team Module

**Infrastructure & Networking.**

This module manages identity for the cloud platform engineers responsible for the foundation.

### Roles
| Role Name | Description | Key Permissions |
|-----------|-------------|-----------------|
| `platform-engineer`| Network Admin | `ec2:*Vpc*`, `ec2:*SecurityGroup*` |
| `datadog` | Observability Agent | Read-only metrics and logs integration |
