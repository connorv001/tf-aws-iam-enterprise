# modules/foundation/golden-ami/ami-builder.tf

resource "aws_iam_role" "ami_builder" {
  name = "golden-ami-builder"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ami_builder.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ami_builder" {
  statement {
    sid    = "AMIManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateImage",
      "ec2:DeregisterImage",
      "ec2:DescribeImages",
      "ec2:CopyImage"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ami_builder" {
  name   = "ami-builder-permissions"
  role   = aws_iam_role.ami_builder.id
  policy = data.aws_iam_policy_document.ami_builder.json
}
