# Project Tracks

This file provides an index of all major tracks for the **tf-aws-iam-enterprise** project.
**This repository is the Central Zero Trust Control Plane for all IAM Roles and Policies.**

## Active Tracks

### Team-Specific Tracks (Centralized Role Registries)
Tracks for each functional team whose roles are managed centrally in this repository:

1. **DevOps & App Identity (Zero Trust)**
   - **Location**: `devops_team/`
   - **Focus**: Centralized definition of EKS (IRSA), Fargate, and CI/CD roles using OIDC.
   - **Scope**: Zero Trust Identity for all Workloads.
   - **SLA**: 100% OIDC Adoption (No Keys)
   - **Last Updated**: 2026-01-12

2. **Security Team**
   - **Location**: `security_team/`
   - **Focus**: Guardrails (SCPs), Threat Detection, and Compliance Monitoring.
   - **Scope**: Organization-wide security posture
   - **SLA**: Continuous Compliance
   - **Last Updated**: 2026-01-12

## Track Structure


## Track Structure

Each track includes:
- `spec.md`: Detailed specifications and architecture
- `plan.md`: Implementation roadmap and operational procedures
- `metadata.json`: Track metadata, dependencies, and SLOs

## Key Features

### Zero Trust Architecture
- **Identity-Centric:** Authentication is required for every request.
- **Least Privilege:** Access is granted only for specific resources and actions.
- **Assume Breach:** Comprehensive logging and monitoring to detect anomalies.

### Centralized Control
- **Single Source of Truth:** All roles are defined here.
- **Global Policy Updates:** Security patches are applied centrally and propagate instantly.
- **Unified Audit:** Complete visibility into "Who has access to What".

## Related Resources

See the following for additional context:
- `conductor/product.md`: Product vision and goals
- `conductor/tech-stack.md`: Technology stack overview
- `conductor/workflow.md`: Development workflow
- `conductor/code_styleguides/general.md`: Code standards

## Archive

The following tracks have been successfully implemented and moved to `conductor/archive/`:

1. **Foundation Track**
   - **Archived**: `foundation_iam_20260112`
   - **Status**: Completed

2. **Platform Team (ITOC) Track**
   - **Archived**: `platform_team_20260112`
   - **Status**: Completed

Deprecated or legacy tracks are also available in `conductor/archive/`

