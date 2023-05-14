terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "eu-central-2"

  endpoints {
    s3  = "https://s3.eu-central-2.wasabisys.com"
    sts = "https://sts.wasabisys.com"
    iam = "https://iam.wasabisys.com"
  }

  s3_use_path_style           = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true
}

# Needed because all IAM policies are set on the `us-east-1` region.
provider "aws" {
  alias = "us_east"
  region = "us-east-1"

  endpoints {
    s3  = "https://s3.wasabisys.com"
    sts = "https://sts.wasabisys.com"
    iam = "https://iam.wasabisys.com"
  }

  s3_use_path_style           = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
}

resource "aws_iam_policy" "policy" {
  provider = aws.us_east
  name     = var.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Effect: "Allow",
          Action: "s3:ListBucket",
          Resource: aws_s3_bucket.bucket.arn
        },
        {
          Effect : "Allow",
          Action : "s3:*Object",
          Resource : [
            "${aws_s3_bucket.bucket.arn}/*",
          ]
        }
      ]
    }
  )
}

resource "aws_iam_user" "user" {
  provider = aws.us_east
  name = var.name
}

resource "aws_iam_access_key" "access_key" {
  provider = aws.us_east
  user = aws_iam_user.user.id
}

resource "aws_iam_user_policy_attachment" "policy" {
  provider = aws.us_east
  user = aws_iam_user.user.id
  policy_arn = aws_iam_policy.policy.arn
}
