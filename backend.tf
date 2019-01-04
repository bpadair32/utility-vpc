terraform {
    backend "s3" {
        bucket = "mocafi-terraform"
        key = "utility/utility.tfstate"
        region = "us-east-1"
        profile = "mocafi"
    }
}