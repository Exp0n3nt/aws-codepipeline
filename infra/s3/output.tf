output "s3_bucket_input" {
  value = {
    name = aws_s3_bucket.glue_s3_input.bucket
    arn  = aws_s3_bucket.glue_s3_input.arn
  }
}

output "s3_bucket_output" {
  value = {
    name = aws_s3_bucket.glue_s3_output.bucket
    arn  = aws_s3_bucket.glue_s3_output.arn
  }
}