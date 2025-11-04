resource "aws_iam_role" "glue_role" {
  name = "glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}
data "aws_iam_policy_document" "glue_assume_role" {
    statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:HeadObject"
    ]
    resources = [
      "${var.s3_bucket_input.arn}",
      "${var.s3_bucket_input.arn}/*",
    ]
  }
}
resource "aws_iam_role_policy" "glue_policy" {
  name   = "glue-policy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}