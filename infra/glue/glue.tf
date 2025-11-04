resource "aws_glue_catalog_database" "DemoDB" {
  name = "DemoDB"
}
resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "DemoTable"
  database_name = aws_glue_catalog_database.DemoDB.name
}
resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.DemoDB.name
  name          = "S3_crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.s3_bucket_input.name}/"
  }
  table_prefix = "demo-"
}