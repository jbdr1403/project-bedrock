resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
  tags = local.common_tags
}
resource "aws_iam_policy" "bedrock_dev_view_s3_put" {
  name = "bedrock-dev-view-s3-put"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "bedrock_dev_view_s3" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = aws_iam_policy.bedrock_dev_view_s3_put.arn
}


resource "aws_iam_user_policy_attachment" "bedrock_dev_view_readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}

data "aws_iam_policy_document" "fluentbit_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:amazon-cloudwatch:fluent-bit"]
    }
  }
}

resource "aws_iam_role" "fluentbit_role" {
  name               = "bedrock-fluentbit-role"
  assume_role_policy = data.aws_iam_policy_document.fluentbit_assume_role.json
}

resource "aws_iam_role_policy_attachment" "fluentbit_attach" {
  role       = aws_iam_role.fluentbit_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
