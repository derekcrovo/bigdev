# These variables must be provided by the user (e.g. TF_VAR_*)
variable "aws_default_az" {
    description = "Availability zone for dev"
}
variable "ssh_key" {
    description = "Private key for SSH access to the EC2 instance"
}
variable "enable_ssh" {
    description = "Permit SSH access to the EC2 instance"
    default = true
}
# Preference variables for dev config
variable "vpc_cidr" {
    description = "CIDR block for the dev VPC"
    default = "10.1.0.0/16"
}
variable "subnet_cidr" {
    description = "CIDR block for the dev subnet"
    default = "10.1.0.0/24"
}
variable "instance_type" {
    description = "Instance type for the dev host"
    default = "t2.xlarge"
}
variable "root_device_size" {
    description = "Size of the root volume in GB"
    default = "100"
}
variable "instance_ami" {
    description = "Instance AMI for the dev host"
    default = "ami-04590e7389a6e577c"
}

data "aws_ami" "latest-ubuntu" {
    most_recent = true
    owners = ["099720109477"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
