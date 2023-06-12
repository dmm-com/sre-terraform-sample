terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// AWSプロバイダー
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Terraform = "true" //Terraform管理は明示的にタグを付与する
    }
  }
}