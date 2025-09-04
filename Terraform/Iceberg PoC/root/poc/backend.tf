terraform {
  backend "s3" {
    bucket = "hcm-def-poc-tfstate"
    key    = "hcm-def-poc-tfstate.tfstate"
    region = "us-east-1"
  }
}
