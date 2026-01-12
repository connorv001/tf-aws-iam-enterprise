# modules/app-role-generator/trust-policy.tf

/*
 * ============================================================================
 *  DATA SOURCE: TRUST POLICY
 * ============================================================================
 *
 *  Why: This document defines the "Authentication" layer for the Role.
 *       It specifies that GitHub Actions (via OIDC) is the trusted entity.
 *
 *  Logic:
 *  - Action: "sts:AssumeRoleWithWebIdentity" (Standard for OIDC).
 *  - Principal: The OIDC Provider ARN created in the `github-oidc` module.
 *  - Condition "sub" (Subject): Matches "repo:<org>/<repo>:*".
 *    This is the CRITICAL security control. It ensures that only workflows
 *    running inside the specified repositories can assume this role.
 *  - Condition "aud" (Audience): Matches "sts.amazonaws.com" to ensure
 *    the token was intended for AWS.
 */

data "aws_iam_policy_document" "trust" {
  statement {
    sid    = "AllowGitHubOIDC"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    # -------------------------------------------------------------------------
    #  Condition: Repository Match
    # -------------------------------------------------------------------------
    # The 'sub' claim from GitHub looks like "repo:octo-org/octo-repo:ref:refs/heads/main".
    # We match on "repo:<org>/<repo>:*" to allow any branch/tag in that repo.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repo in var.github_repositories : "repo:${repo}:*"]
    }

    # -------------------------------------------------------------------------
    #  Condition: Audience Match
    # -------------------------------------------------------------------------
    # Ensures the token was signed by GitHub specifically for AWS STS.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }

  # TODO: Implement GitLab OIDC trust logic here
}