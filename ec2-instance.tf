# Resource - 8 - Ec2 Creation
resource "aws_instance" "my-ec2-vm" {
    ami = "need to be provide based on availabe"
    instance_type = "t2.micro"
    key_key_name = "terraform-key"
    subnet_id = aws_subnet.vpc-dev-public-subnet-1.id
    vpc_security_group_ids = [ aws_security_group.dev-vpc-sg.subnet_id ]
  #  user_data = file("apache-install.sh") #Optional for script file execution
    user_data = <<-EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo service httpd start
    sudo systemctl enable httpd
    echo "<h1> Welcome Bharath Prasad Reddy</h1>" > /var/www/html/index.html
    EOF

}