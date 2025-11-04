resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = local.s3_terraform_state_bucket_name

  tags = {
    Name        = local.s3_terraform_state_bucket_name
  }
}

resource "aws_s3_bucket" "codepipeline_artifact_bucket" {
  bucket = local.s3_codepipeline_artifact_bucket_name

  tags = {
    Name        = local.s3_codepipeline_artifact_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_bucket_pab" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_artifact_bucket_pab" {
  bucket = aws_s3_bucket.codepipeline_artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
