data "aws_ami" "latest_ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "based_on_data" {
    ami = data.aws_ami.latest_ami.id
    instance_type = "t2.medium"
    tags = {
        Name = "created from data source for latest ami of aws linux"
    }
  
}