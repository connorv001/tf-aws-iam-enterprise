# IAM Enterprise Conductor Tracks

This directory contains comprehensive conductor tracks that document and guide the enterprise-grade IAM management system for multi-account AWS deployments.

## Track Overview

### Foundation Track
- **Location**: `foundation_iam/`
- **Purpose**: Establishes core IAM infrastructure, password policies, KMS, naming conventions
- **Status**: Active
- **Owner**: Platform Team

### Team Tracks
Each team track defines the IAM roles, responsibilities, and operations for its team:

1. **DevOps Team** (`devops_team/`)
   - CI/CD pipeline roles
   - Application deployment
   - Multi-account infrastructure automation
   - 50+ managed applications

2. **Platform Team** (`platform_team/`)
   - Infrastructure operations
   - Cloud resource management
   - Platform observability
   - Breakglass emergency access
   - 120+ platform roles

3. **OAT Team** (`oat_team/`)
   - Operations and analytics
   - Data pipeline orchestration
   - Analytics infrastructure
   - Data governance

4. **BI Team** (`bi_team/`)
   - Business intelligence
   - Data warehouse operations
   - Databricks platform
   - Real-time analytics

5. **Security Team** (`security_team/`)
   - Security operations
   - Compliance and audit
   - Threat detection
   - Incident response

## Track Structure

Each track contains:
- `spec.md`: Detailed specifications and architecture
- `plan.md`: Implementation roadmap and procedures
- `metadata.json`: Track metadata and dependencies

## Quick Navigation

| Track | Primary Role | Applications | Status |
|-------|-------------|--------------|--------|
| Foundation | N/A | N/A | Active |
| DevOps | CD/Deployment | 50+ | Active |
| Platform | Operations | 120+ | Active |
| OAT | Analytics/Ops | 10+ | Active |
| BI | Business Intelligence | 10+ | Active |
| Security | Security Ops | Org-wide | Active |

## Using the Tracks

### For New Team Members
1. Read `foundation_iam/spec.md` for architecture overview
2. Read your team's `spec.md` for role responsibilities
3. Review `plan.md` for onboarding procedures

### For Operations
1. Consult team track's `spec.md` for role definitions
2. Follow procedures in `plan.md` for common operations
3. Refer to metadata.json for dependencies and SLOs

### For Auditing
1. Review `spec.md` for required roles and policies
2. Check `plan.md` for audit procedures
3. Use metadata.json for compliance tracking

## Key Concepts

### Naming Convention
All IAM resources follow pattern: `{team}-{component}-{suffix}`
- Suffix: `role`, `policy`, `user` (configurable)
- Separator: `-` (configurable)
- Example: `devops-astro-api-service-role`

### Environment Strategy
- **Production**: Full capabilities with restrictions
- **UAT**: Pre-production testing
- **Platform**: Development and testing
- **Security**: Restricted security operations

### Multi-Account Architecture
- Primary account: IAM definitions
- Spoke accounts: Assume roles via trust relationships
- Cross-account: Enabled for multi-account deployments
- Breakglass: Emergency access for incidents

## Deployment and Maintenance

### Quarterly Reviews
- Review all role definitions
- Assess policy effectiveness
- Plan upcoming enhancements

### Monthly Operations
- Review access patterns
- Validate compliance
- Audit role usage
- Update documentation

### Continuous Monitoring
- Track CloudTrail events
- Monitor role assumption metrics
- Alert on suspicious access
- Maintain security posture

## Related Documentation
- `docs/`: Implementation plans and guides
- `terraform/`: Terraform configurations
- `policies/`: IAM policy templates
- `examples/`: Reference implementations

## Support and Questions
- **Architecture Issues**: Contact Platform Team
- **Team-Specific Questions**: Contact respective team lead
- **Security Concerns**: Escalate to Security Team
- **Policy Clarity**: Refer to Foundation Track specs
