resource "aws_vpc" "module_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true  
    tags = {
      Name = "my_vpc"
    }
}

resource "aws_subnet" "module_public_subnet" {    ///this block is for public subnet and ec2 is under this subnet ///
    vpc_id = aws_vpc.module_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)  
    map_public_ip_on_launch = true
    tags = {
      Name = "module_public_subnet"
    }
}

resource "aws_internet_gateway" "module_igw" {  // must for internet access//
    vpc_id = aws_vpc.module_vpc.id  
}

resource "aws_route_table" "module_route_table" {
    vpc_id = aws_vpc.module_vpc.id  
}

resource "aws_route" "module_route" {
    route_table_id = aws_route_table.module_route_table.id
    gateway_id = aws_internet_gateway.module_igw.id
    destination_cidr_block = "0.0.0.0/0"    
}

resource "aws_route_table_association" "module_route_table_association" {
    subnet_id = aws_subnet.module_public_subnet.id
    route_table_id = aws_route_table.module_route_table.id  
}

resource "aws_subnet" "module_private_subnet" {        ///now private subnet and its settings ////
    vpc_id = aws_vpc.module_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 2)
    map_public_ip_on_launch = false
    tags = {
        Name = "module_private_subnet"
    }
}

resource "aws_route_table" "module_private_route_table" {
    vpc_id = aws_vpc.module_vpc.id  
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Must be "vpc" for NAT Gateway
}

resource "aws_nat_gateway" "nat_for_private" {    //nat gateway //
    subnet_id = aws_subnet.module_public_subnet.id  
    allocation_id = aws_eip.nat_eip.id
    
}

resource "aws_route" "module_private_route" {
    route_table_id = aws_route_table.module_private_route_table.id
    nat_gateway_id = aws_nat_gateway.nat_for_private.id
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "module_route_table_association_private" {
    subnet_id = aws_subnet.module_private_subnet.id
    route_table_id = aws_route_table.module_private_route_table.id  
}

resource "aws_instance" "module_ec2" {
    instance_type = "t2.medium"
    subnet_id = aws_subnet.module_public_subnet.id
    ami = var.ami_id

    tags = {
        Name = "module_public_ec2"
    }
  
}