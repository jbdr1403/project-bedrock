locals {
  assets_bucket_name = "bedrock-assets-${lower(replace(var.student_id, "/", "-"))}"
}

# ---------- S3 BUCKET ----------
resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"

  tags = merge(local.common_tags, {
    Name = "bedrock-assets-${var.student_id}"
  })
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------- IAM ROLE FOR LAMBDA ----------
resource "aws_iam_role" "lambda_role" {
  name = "bedrock-asset-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---------- LAMBDA ----------
resource "aws_lambda_function" "asset_processor" {
  function_name = "bedrock-asset-processor"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.12"
  handler       = "handler.handler"

  filename         = "${path.module}/../lambda/asset-processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/asset-processor.zip")

  tags = local.common_tags
}

# ---------- S3 → LAMBDA PERMISSION ----------
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

# ---------- S3 EVENT ----------
resource "aws_s3_bucket_notification" "assets_event" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
