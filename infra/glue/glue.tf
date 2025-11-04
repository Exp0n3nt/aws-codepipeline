resource "aws_glue_catalog_database" "demodb" {
  name = "demodb"
}
resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "demotable"
  database_name = aws_glue_catalog_database.demodb.name
}
resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.demodb.name
  name          = "S3_crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.s3_bucket_input.name}/"
  }
  table_prefix = "demo-"
}