data "aws_caller_identity" "current" {}
locals{
	s3_terraform_state_bucket_name = "codepipeline-terraform-demo-4"
	dynamo_terraform_state_table_name = "codepipeline-terraform-demo"
	s3_codepipeline_artifact_bucket_name = "codepipeline-artifact-demo-1"
	account_id = data.aws_caller_identity.current.account_id
}
