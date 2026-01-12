# Project Tracks

This file provides an index of all major tracks for the tf-aws-iam-enterprise project. Each track has its own detailed documentation in its respective folder.

## Active Tracks

### Foundation Track
- **Location**: `foundation_iam/`
- **Focus**: Core IAM infrastructure, password policies, KMS management, naming conventions
- **Audience**: All teams
- **Status**: Active
- **Last Updated**: 2026-01-12

### Team-Specific Tracks
Tracks for each functional team managing IAM at scale:

1. **DevOps Team**
   - **Location**: `devops_team/`
   - **Focus**: CI/CD pipelines, application deployment roles, service automation
   - **Scope**: 50+ applications
   - **SLA**: 99.9% pipeline reliability
   - **Last Updated**: 2026-01-12

2. **Platform Team (ITOC)**
   - **Location**: `platform_team/`
   - **Focus**: Infrastructure operations, multi-account management, platform services
   - **Scope**: 120+ roles across infrastructure
   - **SLA**: < 1s role assumption latency
   - **Last Updated**: 2026-01-12

3. **OAT Team (Operations & Analytics)**
   - **Location**: `oat_team/`
   - **Focus**: Data pipelines, analytics infrastructure, operations automation
   - **Scope**: Data management and ETL
   - **SLA**: 99% pipeline reliability
   - **Last Updated**: 2026-01-12

4. **BI Team (Business Intelligence)**
   - **Location**: `bi_team/`
   - **Focus**: Data warehouse, Databricks, analytics, reporting
   - **Scope**: BI infrastructure and tools
   - **SLA**: < 5s query performance
   - **Last Updated**: 2026-01-12

5. **Security Team**
   - **Location**: `security_team/`
   - **Focus**: Security operations, compliance, threat detection, incident response
   - **Scope**: Organization-wide security
   - **SLA**: < 5 min MTTD, < 15 min MTTR
   - **Last Updated**: 2026-01-12

## Track Structure

Each track includes:
- `spec.md`: Detailed specifications and architecture
- `plan.md`: Implementation roadmap and operational procedures
- `metadata.json`: Track metadata, dependencies, and SLOs

## Key Features

### Comprehensive Documentation
- Architecture and design decisions
- Operational procedures and runbooks
- Troubleshooting and recovery guides
- Compliance and audit requirements

### Enterprise-Grade Design
- Multi-account support across all teams
- Least privilege access patterns
- Comprehensive audit logging
- Automated compliance monitoring

### Clear Responsibilities
- Team-specific role definitions
- Permission boundaries and restrictions
- Access control mechanisms
- Escalation procedures

## Maintenance Schedule

### Daily
- Monitor role usage and CloudTrail events
- Alert on suspicious access patterns
- Validate pipeline deployments

### Weekly
- Review access patterns per team
- Validate role assumption metrics
- Update operational dashboards

### Monthly
- Comprehensive access audits
- Policy effectiveness review
- Update documentation
- Plan upcoming changes

### Quarterly
- Strategic role assessment
- Technology and framework updates
- Compliance certification
- Cross-team alignment

## Related Resources

See the following for additional context:
- `conductor/product.md`: Product vision and goals
- `conductor/tech-stack.md`: Technology stack overview
- `conductor/workflow.md`: Development workflow
- `conductor/code_styleguides/general.md`: Code standards

## Archive

Deprecated or archived tracks are available in `conductor/archive/`