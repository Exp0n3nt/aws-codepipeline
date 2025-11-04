################################################
##### CODEPIPELINE IAM ROLES AND POLICIES ######
################################################

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    sid     = "AllowS3BucketAccess"
    effect  = "Allow"
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.codepipeline_artifact_bucket.arn 
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid     = "AllowS3ObjectAccess"
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.codepipeline_artifact_bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [local.account_id]
    }
  }
}

data "aws_iam_policy_document" "codebuild_access_policy" {
  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]

    resources = [
      "arn:aws:codebuild:*:${local.account_id}:project/infra-plan",
      "arn:aws:codebuild:*:${local.account_id}:project/infra-deploy"
    ]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
resource "aws_iam_role_policy" "codebuild_access_policy" {
  name   = "codebuild_access_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codebuild_access_policy.json
}



#############################################
##### CODEBUILD IAM ROLES AND POLICIES ######
#############################################


data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}
data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/codebuild/infra-plan",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/codebuild/infra-plan:*",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/codebuild/infra-deploy",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/codebuild/infra-deploy:*"
    ]
  }

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
      "${aws_s3_bucket.terraform_state_bucket.arn}",
      "${aws_s3_bucket.terraform_state_bucket.arn}/*",
      "${aws_s3_bucket.codepipeline_artifact_bucket.arn}",
      "${aws_s3_bucket.codepipeline_artifact_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:us-east-1:${local.account_id}:report-group/infra-plan-*"
    ]
  }
  
  statement {
    sid    = "AllowDynamoDBForTerraformLocks"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable"
    ]
    resources = [
      "${aws_dynamodb_table.terraform_state_table.arn}"
    ]
  }
}
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}
resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}