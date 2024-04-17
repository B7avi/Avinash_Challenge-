data "aws_ami" "amazonlinux_ami_useast1" {
  most_recent       = true
  owners            = ["137112412989"]

  filter {
    name   = "name"
    values = ["amazon-linux-*"]
  }
}

# Step 1: Set up VPC private for security
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Step 2: Create subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

# Step 3: Configure security groups
resource "aws_security_group" "web" {
  name        = "web_sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Step 4: Launch EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazonlinux_ami_useast1.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.web.name]

  user_data = <<-EOF
              #!/bin/bash
              echo "<html><head><title>Hello World</title></head><body><h1>Hello World!</h1></body></html>" > /var/www/html/index.html
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              EOF
}
