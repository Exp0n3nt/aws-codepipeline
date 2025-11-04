resource "aws_dynamodb_table" "terraform_state_table" {
  name           = local.dynamo_terraform_state_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = local.dynamo_terraform_state_table_name
  }
}
