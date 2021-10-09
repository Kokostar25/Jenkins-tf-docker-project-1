resource "aws_instance" "web-app" {
  count     =   length(var.subnet_cidr)  
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = var.subnet_id[count.index]
  vpc_security_group_ids = [aws_security_group.jenks.id]
  associate_public_ip_address = true
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "web-app-${element(var.availability_zones, count.index)}"
  
  }

}

resource "aws_instance" "jenkins" {
  count                    = 1
  ami                      = var.ami
  instance_type            = "t2.micro"
  key_name                 = var.key_name
  subnet_id                = var.subnet_id[count.index]
  vpc_security_group_ids = [aws_security_group.jenks-sg.id]
  associate_public_ip_address = true
  availability_zone = element(var.availability_zones, count.index)
  user_data = "${file("install-jenkins.sh")}"
  // user_data = <<-EOF
  //         #! /bin/bash
  //         sudo yum -y update
  //         sudo amazon-linux-extras install epel -y
  //         sudo yum-config-manager --enable epel
  //         sudo wget -O /etc/yum.repos.d/jenkins.repo \
  //             https://pkg.jenkins.io/redhat-stable/jenkins.repo
  //         sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  //         sudo yum upgrade
  //         sudo yum install jenkins java-1.8.0-openjdk-devel -y
  //         sudo systemctl daemon-reload
  //         sudo systemctl start jenkins
  //         sudo systemctl status jenkins
  //         EOF


  tags = {
    Name = "jenkins-${element(var.availability_zones, count.index)}"
  
  }

}



resource "aws_security_group" "jenks" {
  name        = "jenks"
  vpc_id      = var.vpc_id

  ingress  {
      description      = "inbound rules from VPC"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      // cidr_blocks      = ["0.0.0.0/0"]
      security_groups   = [aws_security_group.jenk-lb-sg.id]
    }

  ingress  {
      description      = "inbound rules from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }
  // ingress  {
  //     description      = "inbound rules from VPC"
  //     from_port        = 8080
  //     to_port          = 8080
  //     protocol         = "tcp"
  //     cidr_blocks      = ["0.0.0.0/0"]
      
  //   }

  

  egress {

      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]  
    }
  

 
}



resource "aws_lb" "jenk-lb" {
  name               = "jenk-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenks.id]
  subnets            = var.subnet_id

  enable_deletion_protection = false

  tags = {
    Name = "jenk-lb"
  }

}

# Target group for lb

resource "aws_lb_target_group" "jenk-lb" {
  name     = "jenk-lb"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

health_check {
    port     = 3000
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "tf-attach-1" {
  count            = 2
  target_group_arn = aws_lb_target_group.jenk-lb.id
  target_id        = var.ec2_id[count.index]
  port             = 3000
}




resource "aws_lb_listener" "jk-listener" {
  load_balancer_arn = aws_lb.jenk-lb.id
  port              = 3000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.jenk-lb.id
    type             = "forward"
    

  }
}

# Security Group for ALB
resource "aws_security_group" "jenk-lb-sg" {
    name = "jenk-lb-sg"
    description = "allow HTTPS to Load Balancer (ALB)"
    vpc_id = var.vpc_id
    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name = "jenk-lb-sg"
    }
}

resource "aws_security_group" "jenks-sg" {
    name = "jenks-sg"
    description = "For the jenkins server"
    vpc_id = var.vpc_id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  

    ingress  {
      description      = "inbound rules from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }    

    
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name = "jenks-sg"
    }
}