resource "aws_s3_bucket" "glue_s3_input" {
  bucket = var.s3_bucket_input
}
resource "aws_s3_bucket" "glue_s3_output" {
  bucket = var.s3_bucket_output
}