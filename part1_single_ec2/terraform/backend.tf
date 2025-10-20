terraform {
  backend "s3" {
    bucket = "<REPLACE_ME_TF_STATE_BUCKET>"
    key    = "part1/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "<REPLACE_ME_DDB_TABLE>"
    encrypt = true
  }
}
