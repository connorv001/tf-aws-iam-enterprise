# modules/app-role-generator/role.tf

/*
 * ============================================================================
 *  RESOURCE: AWS IAM ROLE
 * ============================================================================
 *
 *  Why: This is the primary identity that applications and CI/CD pipelines
 *       assume to interact with AWS resources.
 *
 *  Security Features:
 *  1. Trust Policy: Generated dynamically to strictly limit assumption to
 *     specific GitHub repositories (OIDC).
 *  2. Permissions Boundary: Attached to ALL roles to ensure they cannot
 *     exceed the organization's maximum allowed permissions (e.g., stopping
 *     CloudTrail or modifying billing).
 *  3. Tagging: Mandatory tags for Cost Allocation and Ownership tracking.
 */

resource "aws_iam_role" "this" {
  name        = var.role_name
  description = var.description

  # ---------------------------------------------------------------------------
  #  TRUST POLICY (The "Who")
  # ---------------------------------------------------------------------------
  # Defined in trust-policy.tf. Controls which OIDC subjects (GitHub Repos)
  # are allowed to assume this role.
  assume_role_policy = data.aws_iam_policy_document.trust.json

  # ---------------------------------------------------------------------------
  #  PERMISSIONS BOUNDARY (The "Limit")
  # ---------------------------------------------------------------------------
  # A Managed Policy that sets the maximum intersection of permissions.
  # Even if `inline_policy` grants AdminAccess, the effective permissions
  # cannot exceed what is allowed by this boundary.
  permissions_boundary = var.permissions_boundary_arn

  # ---------------------------------------------------------------------------
  #  METADATA & TAGGING
  # ---------------------------------------------------------------------------
  tags = merge(
    var.tags,
    {
      "Team"        = var.team
      "Application" = var.app_name
      "ManagedBy"   = "terraform-app-role-generator"
    }
  )
}

/*
 * ============================================================================
 *  INLINE POLICY (Optional)
 * ============================================================================
 *  Why: Allows defining specific, granular permissions directly on the role
 *       without managing a separate Customer Managed Policy resource.
 *  Best Practice: Use for app-specific logic (e.g., access to specific S3 buckets).
 */
resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy != null ? 1 : 0
  name   = "app-permissions"
  role   = aws_iam_role.this.id
  policy = var.inline_policy
}

/*
 * ============================================================================
 *  MANAGED POLICY ATTACHMENTS (Optional)
 * ============================================================================
 *  Why: Attach reusable policies (e.g., ReadOnlyAccess, ViewOnlyAccess).
 */
resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}