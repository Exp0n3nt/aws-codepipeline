locals {
  vpc_cidr         = "10.0.0.0/16"
  public_cidr      = "10.0.1.0/24"
  private_cidr     = "10.0.2.0/24"
  s3_bucket_input  = "codepipeline-glue-s3-input-demo"
  s3_bucket_output = "codepipeline-glue-s3-output-demo"
}
