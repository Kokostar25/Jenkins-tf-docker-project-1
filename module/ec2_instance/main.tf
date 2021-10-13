resource "aws_instance" "web-app" {
  count     =   2  
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = var.subnet_id[count.index]
  vpc_security_group_ids = [aws_security_group.jenks.id]
  associate_public_ip_address = true
  availability_zone = element(var.availability_zones, count.index)
  user_data = "${file("install-docker.sh")}"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_web_app.name

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

# ECR

resource "aws_ecr_repository" "appimage" {
  name                 = "appimage"
  image_tag_mutability = "MUTABLE"

  }

#EC2 Profile

resource "aws_iam_role" "ec2_role_web_app" {
  name = "web_app"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    project = "web_app"
  }
}

resource "aws_iam_instance_profile" "ec2_profile_web_app" {
  name = "ec2_profile_web_app"
  role = aws_iam_role.ec2_role_web_app.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role_web_app.id

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}