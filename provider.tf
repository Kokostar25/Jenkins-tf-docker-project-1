provider "aws" {
  region = var.region
  profile = "iamadmin-general"
}


provider "docker" {
  registry_auth {
      address = local.aws_ecr_url
      username = data.aws_ecr_authorization_token.token.user_name
      password = data.aws_ecr_authorization_token.token.password

  }
}










