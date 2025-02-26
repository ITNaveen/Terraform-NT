data "aws_ami" "amazon_linux_2" {   //this is to find latest ami on amazon linux2
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]   //thats the pattern i need for finding ami.
    }
}

resource "aws_instance" "amz2-latest" {
    ami = data.aws_ami.amazon_linux_2.id
    instance_type = "t2.micro"
    tags = {
        Name = "amz_lin_2"
    }
  
}

data "aws_ami" "ubuntu" {  //for ubuntu
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]    //thats for ubuntu 22.04
    }
}

resource "aws_instance" "ubuntu22" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    tags = {
      Name = "ubuntu_22"
    }
  
}

data "aws_ami" "ubuntu_18" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]  // thats for ubuntu 18.04
    }
}

resource "aws_instance" "ubuntu18" {
    ami = data.aws_ami.ubuntu_18.id
    instance_type = "t2.micro"
    tags = {
        Name = "ubuntu_18"
    }

}

output "amazon_ami" {
    value = data.aws_ami.amazon_linux_2.id  
}

output "ubuntu_22" {
  value = data.aws_ami.ubuntu.id
}

output "ubuntu_18" {
    value = data.aws_ami.ubuntu_18.id
  
}