resource "aws_vpc" "node-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Node-vpc"
  }
}

resource "aws_subnet" "s1" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.node-vpc.id
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "s2" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.node-vpc.id
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "s3" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.node-vpc.id
  availability_zone = "ap-south-1c"
  map_public_ip_on_launch = true

}

resource "aws_security_group" "node-sg" {
    name = "node-sg"
    vpc_id = aws_vpc.node-vpc.id

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Strapi"
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.node-vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.node-vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  route  {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "route1" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.s1.id
}

resource "aws_route_table_association" "route2" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.s2.id
}

resource "aws_route_table_association" "route3" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.s3.id
}
