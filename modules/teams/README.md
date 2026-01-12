# Team Governance Modules

**The Registry of Identity.**

---

## 📖 Overview

The `modules/teams` directory implements the **Governance Layer** of the framework. Instead of managing hundreds of disparate IAM roles in a single state file, we organize them by **Team Ownership**.

### The Pattern
Each team (e.g., `devops`, `platform`, `sre`) has its own module that acts as a **registry** for their application roles.

1. **Isolation:** Team A cannot accidentally modify Team B's roles.
2. **Standardization:** All roles are created using the standard `app-role-generator` factory.
3. **Toggleable:** Roles can be enabled/disabled per environment using the `enabled_roles` variable map.

---

## 🏗 Directory Structure

```
modules/teams/
├── devops/             # Backend services, frontend apps
├── platform/           # VPC, Networking, Shared Infra
├── sre/                # Observability, Chaos Engineering
├── data/               # Data Lake, Athena, Glue
└── security/           # GuardDuty, Audit, Compliance
```

---

## 🛠 Adding a New Team

To onboard a new team (e.g., `mobile`):

1. Create `modules/teams/mobile/`.
2. Create `main.tf` with `locals { team_name = "mobile" }`.
3. Create `variables.tf` accepting `oidc_provider_arn` and `permissions_boundary_arn`.
4. Add roles as individual `.tf` files (e.g., `ios-app.tf`) using the generator.
