terraform {
    backend "s3" {
        bucket = "adair-tech-terraform"
        key = "utility/utility.tfstate"
        region = "us-east-1"
        profile = "adair-tech"
    }
}