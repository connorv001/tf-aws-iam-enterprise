# DevOps Team IAM Track Specification

## Overview
The DevOps team module manages IAM roles and policies for CI/CD pipelines, service deployment roles, and automation infrastructure. It encompasses roles for applications managed by the devops team across multiple environments.

## Team Composition
- DevOps Engineers
- DevOps Lead Engineers
- DevOps Service Connection Users (Azure DevOps integration)
- Pipeline automation accounts

## Core Responsibility Areas
1. **CI/CD Pipeline Management**
   - GitHub Actions integration via OIDC
   - Azure DevOps pipeline role management
   - Automated deployment role creation

2. **Application Deployment Roles**
   - Service-to-service authentication
   - Container registry access
   - Infrastructure deployment permissions

3. **Multi-Account Deployment**
   - Cross-account assume roles for spoke accounts
   - Environment-specific role configurations
   - Secure credential handling via KMS

## Applications Managed
The devops module manages roles for 50+ applications including:
- astro-api-service
- background_processor
- eclipse_* (multiple services)
- element_* (multiple services)
- webapi, webcomponent
- wealth_management_platform_* (multiple services)
- And many more production applications

## Module Structure
```
modules/devops/
├── main.tf
├── api-gateway.tf
├── astro-api-service.tf
├── background_processor.tf
├── ... (50+ application-specific files)
├── data_sources.tf
├── variables.tf
├── versions.tf
└── README.md
```

## Key Variables
- `applications`: Map of application names to numeric identifiers
- `kms_key_id`: KMS key for secrets encryption
- `tags`: Resource tags including team, cost center
- `policy_suffix`, `role_suffix`, `user_suffix`: Naming customization

## Access Patterns
1. **Service-to-Service**: Assume role policies for inter-service communication
2. **Pipeline-to-Infrastructure**: CI/CD pipelines assume roles to deploy resources
3. **Cross-Account**: Pipeline roles in primary account assume roles in spoke accounts
4. **Breakglass**: Emergency access roles for incident response

## Success Metrics
- All pipeline roles operational across all applications
- Zero credential exposure in CI/CD logs
- Sub-second cross-account role assumption
- Monthly audit of role usage via CloudTrail

## Maintenance Requirements
- Quarterly application onboarding
- Monthly policy permission reviews
- Immediate response to failed deployments
- Continuous monitoring of role usage patterns
