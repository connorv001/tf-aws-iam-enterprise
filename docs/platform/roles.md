# Platform Team IAM Roles

This document outlines the IAM roles and permissions for the Platform Engineering and Architectural teams.

## Roles Overview

| Role Name | Audience | Key Permissions |
|-----------|----------|-----------------|
| `platform-engineer` | Platform Engineers | Network, S3, EC2 administration |
| `platform-architect` | Architects | Read-only infra + Policy versioning |
| `enterprise-architect` | Leadership | Organization-wide ReadOnly |
| `solution-architect` | Project Members | ViewOnly Access |
| `network-engineer` | Network Ops | VPC, DirectConnect, Transit Gateway |
| `security-engineer` | Security Ops | SecurityHub, GuardDuty, Audit |
| `cloud-data-engineer` | Data Ops | RDS, Glue, Redshift |
| `platform-breakglass` | Emergencies | AdministratorAccess (1hr limit) |

## JIT & Breakglass Procedures

### Breakglass Access
The `platform-breakglass` role is reserved for critical incident response.
- **Alerting**: Any session start triggers a `CRITICAL` CloudWatch alarm.
- **Approval**: Must be triggered via OIDC from approved GitHub repositories.
- **Session Limit**: Maximum 1 hour session duration.

### Monitoring
Integration with Datadog and CloudWatch Logs is enabled for all platform resources to ensure complete visibility.
