resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
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
