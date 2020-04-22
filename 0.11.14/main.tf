provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "712999270095-us-west-2-tf-state"
    key    = "01114/volume.json"
    region = "us-west-2"
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "us-west-2a"
  size              = 5

  tags = {
    Name = "Demo"
  }
}

output "volume_id" {
  value = "${aws_ebs_volume.volume.id}"
}
