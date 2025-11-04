# resource "aws_kms_alias" "mykmsalias" {
#   name          = "alias/myKmsKey"
#   target_key_id = aws_kms_key.mykey.id
# }

# resource "aws_kms_key" "mykey" {
#   description = "KMS key for S3 artifact encryption"
# }


# resource "aws_codepipeline" "Demo" {
#   name     = "Demo"
#   role_arn = aws_iam_role.codepipeline_role.arn

#   artifact_store {
#     location = aws_s3_bucket.codepipeline_artifact_bucket.bucket
#     type     = "S3"

#     encryption_key {
#       id   = aws_kms_alias.mykmsalias.arn
#       type = "KMS"
#     }
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "ThirdParty"
#       provider         = "GitHub"
#       version          = "1"
#       output_artifacts = ["SourceOutput"]

#       configuration = {
#         Owner      = "Exp0n3nt"
#         Repo       = "aws-codepipeline"
#         Branch     = "main"
#         OAuthToken = var.github_oauth_token
#       }
#     }
#   }

#   stage {
#     name = "Plan"

#     action {
#       name             = "Plan"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["SourceOutput"]
#       output_artifacts = ["PlanOutput"]
#       version          = "1"

#       configuration = {
#         ProjectName = "infra-plan"
#       }
#     }
#   }

#   stage {
#     name = "Approval"

#     action {
#       name     = "Approval"
#       category = "Approval"
#       owner    = "AWS"
#       provider = "Manual"
#       version  = "1"
#     }
#   }

#   stage {
#     name = "Deploy"

#     action {
#       name             = "Deploy"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["SourceOutput", "PlanOutput"]
#       output_artifacts = []
#       version          = "1"

#       configuration = {
#         ProjectName = "infra-deploy"
#       }
#     }
#   }
# }

# resource "aws_codestarconnections_connection" "github" {
#   name          = "github-connection"
#   provider_type = "GitHub"
# }
