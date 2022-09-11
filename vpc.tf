#resource
#Resource - 1 - Create VPC
resource "aws_vpc" "tf_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "ts_vpc"
    } 
}
#Resource - 2 - Create Subnet
resource "aws_subnet" "vpc-dev-public-subnet-1" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
     
}

#Resource - 3 - Create Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
    vpc_id = aws_vpc.tf_vpc.id  
}

#Resource - 4 - Create Route Table
resource "aws_route_table" "vpc-public-route-table" {
    vpc_id = aws_vpc.tf_vpc.id
     
}

#Resource - 5 - Create Route in Route Table for Internet Access
resource "aws_route" "vpc-dev-route" {
    route_table_id = aws_route_table.vpc-public-route-table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-dev-igw.id
  
}

#Resource - 6 - Associate the Route Table with the subnet 
resource "aws_route_table_association" "vpc-dev-public-route-table-association" {
    route_table_id = aws_route_table.vpc-public-route-table.id
    subnet_id = aws_subnet.vpc-dev-public-subnet-1.id
  
}

#Resource - 7 - Create Security Group
resource "aws_security_group" "dev-vpc-sg" {
    name = "dev-vpc-default-sg"
    description = "Dev default vpc security group"
    vpc_id = aws_vpc.tf_vpc.id

    ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  
  }
    ingress {
    description      = "Allow port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    description = "allow all IP and Ports Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
  
}