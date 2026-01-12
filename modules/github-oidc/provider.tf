# modules/github-oidc/provider.tf

/*
 * ============================================================================
 *  DATA SOURCE: TLS CERTIFICATE
 * ============================================================================
 *
 *  Why: AWS IAM requires the SHA1 fingerprint of the OIDC provider's
 *       server certificate to establish trust.
 *
 *  Logic: Instead of hardcoding the fingerprint (which changes over time),
 *         we dynamically fetch it from the URL during the plan phase.
 */
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

/*
 * ============================================================================
 *  RESOURCE: OIDC PROVIDER
 * ============================================================================
 *
 *  Why: Creates the Identity Provider entity in IAM. This tells AWS to trust
 *       tokens issued by "token.actions.githubusercontent.com".
 *
 *  Configuration:
 *  - client_id_list: "sts.amazonaws.com" is the standard audience for AWS.
 *  - thumbprint_list: The dynamic SHA1 hash from the cert above.
 */
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = var.tags
}