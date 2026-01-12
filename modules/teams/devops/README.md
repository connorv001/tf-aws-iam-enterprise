# DevOps Team Module

**Application Delivery & Operations.**

This module manages identity for the software engineering teams building user-facing products.

### Roles
| Role Name | Description | Key Permissions |
|-----------|-------------|-----------------|
| `backend-service` | ECS/Lambda Services | `ecs:UpdateService`, `logs:PutLogEvents` |
| `devops-engineer` | Human Operator | Read-only access to ECS/RDS/Lambda for debugging |
