variable "s3_bucket_input" {
  type = object({
    name = string
    arn  = string
  })
}

variable "s3_bucket_output" {
  type = object({
    name = string
    arn  = string
  })
}
