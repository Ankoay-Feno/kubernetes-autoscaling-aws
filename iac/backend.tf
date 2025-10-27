# terraform {
#   backend "s3" {
#     bucket = "terraform-state-bucket"
#     region = "eu-west-3"
#     encrypt = true
#     dynamodb_table = "terraform-lock-table"
#   }
# }