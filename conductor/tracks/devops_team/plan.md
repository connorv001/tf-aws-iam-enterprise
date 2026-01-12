# DevOps & App Identity IAM Implementation Plan (Zero Trust)

**Focus:** Centralized definition of Zero Trust Application Identity. This track builds the "Registry" of roles that applications consume via OIDC.

## Phase 1: Core Zero Trust Infrastructure (Weeks 1-2)

### 1.1 OIDC Identity Federation (No Keys)
- [x] Configure GitHub Actions OIDC Provider (Eliminate CI/CD Access Keys)
- [ ] Configure EKS OIDC Providers for IRSA (Eliminate Node/Pod Access Keys)
- [ ] Establish trust policies for external CI/CD systems (Strict `aud` and `sub` matching)
- [ ] **Validation:** Verify token exchange fails if audience or subject claims do not match exactly.

### 1.2 Base Application Role Registry
- [ ] Create `modules/teams/devops/app-server-base` role pattern with strict boundaries
- [ ] Implement Instance Profile generation modules with IMDSv2 enforcement
- [ ] Define standard permissions (SSM Session Manager, CloudWatch Logs, X-Ray) - **Deny All Else**
- [ ] **Validation:** Verify instance connectivity and logging without long-term keys

## Phase 2: EKS & Kubernetes Identity (Weeks 2-3)

### 2.1 EKS Node & Cluster Roles
- [ ] Centralize definition of EKS Node Group roles (Standard vs. GPU/Specialized)
- [ ] Centralize definition of EKS Fargate Pod Execution Roles
- [ ] Implement "Least Privilege" for CNI and CSI drivers (VPC CNI, EBS CSI)
- [ ] **Validation:** Verify node join status and driver functionality

### 2.2 IAM Roles for Service Accounts (IRSA) Registry
- [ ] Create central module for mapping K8s ServiceAccounts to IAM Roles
- [ ] Define namespace-based permission boundaries in the central registry
- [ ] Implement specific roles for:
    - [ ] ExternalDNS (Route53 access)
    - [ ] ALB Ingress Controller (ELB/WAF access)
    - [ ] Cluster Autoscaler (ASG access)
    - [ ] App-specific S3/DynamoDB access roles
- [ ] **Validation:** Deploy test pod with annotated ServiceAccount and verify AWS CLI access

## Phase 3: Serverless & Container Integration (Weeks 3-4)

### 3.1 ECS & Fargate Patterns
- [ ] Define **Task Execution Roles** (Image pull, logs, secrets)
- [ ] Define **Task Roles** (Application specific permissions)
- [ ] Create reusable Terraform modules for ECS Service IAM attachment
- [ ] **Validation:** Verify Fargate task startup and application AWS SDK calls

### 3.2 Lambda & Event Integration
- [ ] Create Lambda execution role templates
- [ ] Define EventBridge/SNS/SQS invocation permissions
- [ ] Implement X-Ray tracing permissions by default
- [ ] **Validation:** End-to-end test of Event -> Lambda -> Data Store flow

## Phase 4: CI/CD & Automation Integration (Weeks 4-5)

### 4.1 Pipeline Roles Registry
- [ ] Refine GitHub Actions roles for specific repositories/environments (sub-claim matching)
- [ ] Create "Terraform Apply" roles with restricted scope per environment
- [ ] Implement "Image Builder" roles for AMI/Container build pipelines
- [ ] **Validation:** Verify pipeline failure on out-of-scope access attempts

### 4.2 GitOps & ArgoCD (Optional/Advanced)
- [ ] If using ArgoCD: Define ArgoCD repo-server and controller roles
- [ ] Define cross-account roles for ArgoCD multi-cluster management
- [ ] **Validation:** Verify ArgoCD sync capabilities

## Phase 5: Governance & Monitoring (Week 6+)

### 5.1 Access Analyzer & Guardrails
- [ ] Enable IAM Access Analyzer for external access verification
- [ ] Implement Service Control Policies (SCPs) to protect critical roles
- [ ] Set up alerts for `AdministratorAccess` usage
- [ ] **Validation:** Trigger alert on simulated policy violation

## Success Criteria
- **Zero Trust:** 100% of machine-to-machine auth uses OIDC/IRSA.
- **No Long-Lived Keys:** Static Access Keys are prohibited.
- **Centralization:** 100% of application roles are defined in this repository.