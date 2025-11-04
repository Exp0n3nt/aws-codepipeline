resource "aws_codebuild_project" "infra_plan" {
  name          = "infra-plan"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
  
  source {
  	type = "CODEPIPELINE"
  	buildspec = file("./buildspec-plan.yaml")
  }
  
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_artifact_bucket.bucket}/infra-plan/build-log"
    }
  }

}

resource "aws_codebuild_project" "infra_deploy" {
  name          = "infra-deploy"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
  
  source {
  	type = "CODEPIPELINE"
  	buildspec = file("./buildspec-deploy.yaml")
  }
  
  logs_config {
    cloudwatch_logs {
      status = "ENABLED" 
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_artifact_bucket.bucket}/infra-deploy/build-log"
    }
  }

}
