# TF AWS dev env

provider "aws" {}

resource "aws_vpc" "dev-vpc"  {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
}

resource "aws_subnet" "dev-subnet" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.aws_default_az
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

resource "aws_route_table" "dev-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev-igw.id
    }
}

resource "aws_route_table_association" "dev-rta" {
    subnet_id = aws_subnet.dev-subnet.id
    route_table_id = aws_route_table.dev-rt.id
}

resource "aws_security_group" "dev-ssh-sg" {
        name            = "dev-ssh-sg"
        description     = "SSH only access"
        vpc_id          = aws_vpc.dev-vpc.id
        ingress {
            from_port       = 22
            to_port         = 22
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }

        egress  {
            from_port       = 0
            to_port         = 0
            protocol        = -1
            cidr_blocks     = ["0.0.0.0/0"]
        }
}

resource "aws_security_group" "dev-noaccess-sg" {
        name            = "dev-noaccess-sg"
        description     = "No direct access, use Tailscale VPN"
        vpc_id          = aws_vpc.dev-vpc.id
        egress  {
            from_port       = 0
            to_port         = 0
            protocol        = -1
            cidr_blocks     = ["0.0.0.0/0"]
        }
}

resource "aws_instance" "bigdev" {
    ami = data.aws_ami.latest-ubuntu.image_id
    instance_type = var.instance_type
    availability_zone = var.aws_default_az
    key_name = "dev-tf"
    subnet_id = aws_subnet.dev-subnet.id
    vpc_security_group_ids = [
        var.enable_ssh ? aws_security_group.dev-ssh-sg.id : aws_security_group.dev-noaccess-sg.id
    ]
    root_block_device {
        volume_size = var.root_device_size # GB
    }
    tags = {
        Name = "bigdev"
    }
}
