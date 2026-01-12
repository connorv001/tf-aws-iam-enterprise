# Enterprise IAM Foundation Track Specification

## Overview
This track documents the foundational IAM infrastructure that enables all team modules and multi-account management. It establishes the baseline security posture, naming conventions, tagging standards, and configuration patterns used across the organization.

## Objectives
1. Define the core IAM structure and organizational principles
2. Document account password policies and security baselines
3. Establish naming conventions for roles, policies, and users
4. Define KMS key management for secrets encryption
5. Outline multi-account access patterns and cross-account role assumptions

## Key Components

### 1. Foundation Layer
- **Password Policies**: Enforce 12+ character passwords, uppercase, lowercase, numbers, symbols, 90-day max age
- **KMS Key Management**: Centralized encryption for secrets using AWS KMS
- **Account Password Policy**: `aws_iam_account_password_policy.strict` enforcing enterprise security standards
- **Tagging Conventions**: Standardized tags via `tf-module-tagging` v1.0.8 for cost allocation and resource tracking

### 2. Naming Conventions
The system uses a separator-based naming pattern:
- Default separator: `-` (configurable via `sep` variable)
- Role suffix: `role` (configurable via `role_suffix`)
- Policy suffix: `policy` (configurable via `policy_suffix`)
- User suffix: `user` (configurable via `user_suffix`)

Pattern: `{team}-{component}-{suffix}`
Example: `devops-astro-api-service-role`

### 3. Multi-Account Architecture
- **Primary Account**: Hosts IAM definitions and policy templates
- **Spoke Accounts**: Assume roles defined in primary account
- **Cross-Account Assume Roles**: Enabled via trust relationships for multi-account deployment
- **Breakglass Access**: Emergency access roles for incident response

### 4. KMS Integration
- All secrets encrypted with designated KMS keys
- Key aliases for environment-specific encryption
- Separate keys for different security tiers (standard, high)

## Environment Configurations
The system supports multiple environment configurations:
- control_tower: AWS Control Tower management
- production: Production workloads
- uat: User acceptance testing
- platform: Platform infrastructure
- platformtest: Platform testing
- review: Code review/staging
- review_codeinsight: CodeInsight review
- rc: Release candidate
- audit: Compliance and audit
- logging: Centralized logging
- networking: Network infrastructure
- directory: Directory services
- security: Security operations
- archive: Archive/legacy systems

## Success Criteria
- All password policies comply with enterprise standards
- Naming conventions standardized across all resources
- KMS keys properly configured for encryption
- Tagging applied consistently to all IAM resources
- Cross-account access patterns documented
