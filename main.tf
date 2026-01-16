
terraform {
  required_version = "1.5.6"


  backend "s3" {
    bucket         = "test-rate-platform"
    dynamodb_table = "terraform-state-lock-test-platform"
    key            = "env0-poc-multiple-provider/env0-test-project-mp.tfstate"
    region         = "us-east-1"
    # role_arn       = "arn:aws:iam::459772859073:role/test-platform-state-role"
    # profile        = "nonprod-platform-JuniorCPE"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::459772859073:role/TerraformExecutorRole_JuniorCPE"
  }
}

provider "aws" {
  alias = "nonprod"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::420127996065:role/TerraformExecutorRole_JuniorCPE"
  }
  
}

module "tagging" {
source           = "./modules/tagging"

  business_contact = "andrew.hill@rate.com"
  business_owner   = "andrew hill"
  tech_contact     = "cpe@rate.com"
  tech_owner       = "cpe-team"
  code_repo        = "https://github.com/Guaranteed-Rate/test-terraform-repo-v2"
  compliance       = "none"
  criticality      = "high"
  environment      = "nonprod"
  product          = "cloud networking and guardrails"
  public_facing    = "no"
  retirement_date  = "2036-12-31"
}

resource "random_integer" "test_bucket" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-yogi-env0-loc-v1-demo-multi${random_integer.test_bucket.result}"
  tags = merge(module.tagging.value, {
    "PermissionsBoundary" = "JuniorCPE_PermissionsBoundary"
  })
}

resource "aws_s3_bucket" "test_bucket_nonprod" {
  provider = aws.nonprod
  bucket = "test-bucket-yogi-env0-loc-v1-demo-multi-nonprod1${random_integer.test_bucket.result}"
  tags = merge(module.tagging.value, {
    "PermissionsBoundary" = "JuniorCPE_PermissionsBoundary"
  })
}