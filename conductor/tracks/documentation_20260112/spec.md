# Track Spec: Documentation & Developer Experience

## Overview
This track focuses on elevating the project's documentation and code readability to an "extremely handsome" standard. The goal is to make the codebase self-explanatory, visually appealing, and educational for engineers.

## Objectives
- **Polished READMEs:** Create a top-level README and module-level READMEs with professional formatting, badges, table of contents, and ASCII/Mermaid diagrams.
- **Rich Annotations:** Add "JSDoc-style" or decorative comments to Terraform code explaining the *security logic* and *architectural intent* behind key resources (e.g., trust policies, boundaries).
- **Interlinking:** Ensure all documentation is properly cross-referenced.

## Scope
1.  **Top-Level README:**
    - Badges (CI, License, Terraform Version).
    - "The Why": Problem vs. Solution.
    - Architecture Diagram (Mermaid).
    - Quick Start Guide.
    - Directory Structure Walkthrough.

2.  **Module Documentation (`app-role-generator` & `github-oidc`):**
    - `README.md`: Usage, Inputs, Outputs, Compliance Mapping.
    - Code Annotations:
        - `role.tf`: Explain permission boundaries.
        - `trust-policy.tf`: Explain OIDC subject conditions.

3.  **Team Modules Documentation:**
    - Brief READMEs for `devops` and `platform` explaining their role in the governance model.

## Style Guide
- **Tone:** Professional yet engaging ("Handsome").
- **Comments:** Use ASCII decorations for section headers in code.
    ```hcl
    /*
     * -----------------------------------------------------------------------------
     *  RESOURCE: IAM ROLE
     * -----------------------------------------------------------------------------
     *  Why: The core identity for the application.
     *  Security: Must have a boundary attached to prevent privilege escalation.
     */
    ```
