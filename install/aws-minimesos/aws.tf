variable "aws_region" {
  default = "eu-west-1"
}

provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

// Ubuntu 14.04 official hvm:ssd volumes to their region.
variable "aws_amis" {
  default = {
    ap-northeast-1 = "ami-63b44a02"
    ap-southeast-1 = "ami-21d30f42"
    eu-central-1   = "ami-26c43149"
    eu-west-1      = "ami-ed82e39e"
    sa-east-1      = "ami-dc48dcb0"
    us-east-1      = "ami-3bdd502c"
    us-west-1      = "ami-48db9d28"
    cn-north-1     = "ami-bead78d3"
    us-gov-west-1  = "ami-6770ce06"
    ap-southeast-2 = "ami-ba3e14d9"
    us-west-2      = "ami-d732f0b7"

  }
}

resource "aws_vpc" "terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "terraform"
  }
  tags = {
    yor_trace = "20b64bd2-8c7c-4343-abb2-06dd7a993c32"
  }
}

resource "aws_internet_gateway" "terraform" {
  vpc_id = "${aws_vpc.terraform.id}"
  tags {
    Name = "terraform"
  }
  tags = {
    yor_trace = "d4b462b1-b3f3-4401-9531-9bd115cc645e"
  }
}

resource "aws_subnet" "terraform" {
  vpc_id     = "${aws_vpc.terraform.id}"
  cidr_block = "10.0.0.0/24"
  tags {
    Name = "terraform"
  }
  availability_zone = "eu-west-1b"

  map_public_ip_on_launch = true
  tags = {
    yor_trace = "fa5b2310-dfd6-4122-9742-f350d227d1b3"
  }
}

resource "aws_route_table" "terraform" {
  vpc_id = "${aws_vpc.terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform.id}"
  }

  tags {
    Name = "terraform"
  }
  tags = {
    yor_trace = "ec26c68d-5f50-49d4-b3cb-b8954bcc6485"
  }
}

// The Route Table Association binds our subnet and route together.
resource "aws_route_table_association" "terraform" {
  subnet_id      = "${aws_subnet.terraform.id}"
  route_table_id = "${aws_route_table.terraform.id}"
}

// The AWS Security Group is akin to a firewall. It specifies the inbound
// only open required ports in a production environment.
resource "aws_security_group" "terraform" {
  name   = "terraform-web"
  vpc_id = "${aws_vpc.terraform.id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    yor_trace = "aef94a15-ad67-4193-a38e-06a2be9a54c9"
  }
}
