resource "aws_vpc" "utility" {
    cidr_block = "172.20.0.0/16"
    enable_dns_hostnames = "true"
    tags {
        Name = "utility"
        ManagedBy = "terraform"
    }
}

resource "aws_internet_gateway" "igw-utility" {
    vpc_id = "${aws_vpc.utility.id}"
    tags {
        Name = "igw-utility"
    }
}

resource "aws_subnet" "public-1a" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "172.20.1.0/24"
    availability_zone = "us-east-1a"
    tags {
        Name = "utility-public-1a"
    }
}

resource "aws_subnet" "public-1b" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "172.20.2.0/24"
    availability_zone = "us-east-1b"
    tags {
        Name = "utility-public-1b"
    }
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.utility.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-utility.id}"
}

resource "aws_route_table_association" "public-1a_assocation" {
    subnet_id = "${aws_subnet.public-1a.id}"
    route_table_id = "${aws_vpc.utility.main_route_table_id}"
}

resource "aws_route_table_association" "public-1b_assocation" {
    subnet_id = "${aws_subnet.public-1b.id}"
    route_table_id = "${aws_vpc.utility.main_route_table_id}"
}

resource "aws_security_group" "mocafi-utility-jenkins" {

    description = "Security group for Jenkins server"
    egress {
        cidr_blocks        = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
        from_port = 0
        protocol = -1
        self = false
        to_port = 0
    }
    ingress {
        cidr_blocks = ["107.11.61.145/32"]
        description = "SSH Access for Brad"
        from_port = 22
        protocol = "tcp"
        self = false
        to_port = 22
    }
    ingress {
        cidr_blocks = ["107.215.231.50/32"]
        description = "SSH Access for Mika"
        from_port = 22
        protocol = "tcp"
        self = false
        to_port = 22
    }  
    ingress {
        cidr_blocks = ["107.11.61.145/32"]
        description = "Jenkins access for Brad"
        from_port = 8080
        protocol = "tcp"
        self = false
        to_port = 8080
    }
    ingress {
        cidr_blocks = ["107.215.231.50/32"]
        description = "Jenkins Access for Mika"
        from_port = 8080
        protocol = "tcp"
        self = false
        to_port = 8080
    }
    name                                  = "utility-jenkins"
    vpc_id                                = "${aws_vpc.utility.id}"

}