terraform {

  backend "s3" {

    bucket = "sre-dd-state-j9mbsl"

    key = "global/terraform.tfstate"

    region       = "ca-central-1"
    use_lockfile = true


    encrypt = true

  }

}