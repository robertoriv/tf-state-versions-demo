provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "712999270095-us-west-2-tf-state"
    key    = "01107/demo.json"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "volume_state" {
  backend = "s3"

  config = {
    bucket = "712999270095-us-west-2-tf-state"
    key    = "01114/volume.json"
    region = "us-west-2"
  }
}

output "volume_id" {
  value = "${data.terraform_remote_state.volume_state.volume_id}"
}
