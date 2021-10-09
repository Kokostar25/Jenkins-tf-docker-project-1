// resource "aws_security_group" "sg-jenkins" {
//   name        = "sg-jenkins"
//   vpc_id      = var.vpc_id

//   ingress = [
//     {
//       description      = "inbound rules from VPC"
//       from_port        = 3000
//       to_port          = 3000
//       protocol         = "tcp"
//       cidr_blocks      = ["0.0.0.0/0"]
//       security_groups   = [aws_security_group.jenk-lb-sg.id]
//     },

//     {
//       description      = "inbound rules from VPC"
//       from_port        = 22
//       to_port          = 22
//       protocol         = "tcp"
//       cidr_blocks      = ["0.0.0.0/0"]
      
//     }

//   ]

//   egress = [
//     {
//       from_port        = 0
//       to_port          = 0
//       protocol         = "-1"
//       cidr_blocks      = ["0.0.0.0/0"]  
//     }
//   ]

//   tags = {
//     Name = "sg-jenkins"
//   }
// }



// resource "aws_lb" "jenk-lb" {
//   name               = "jenk-lb"
//   internal           = false
//   load_balancer_type = "application"
//   security_groups    = [aws_security_group.sg-jenkins.id]
//   subnets            = aws_subnet.public.*.id

//   enable_deletion_protection = false

//   tags = {
//     Name = "jenk-lb"
//   }

// }

// # Target group for lb

// resource "aws_lb_target_group" "jenk-lb" {
//   name     = "jenk-lb"
//   port     = 3000
//   protocol = "HTTP"
//   vpc_id   = var.vpc_id

// health_check {
//     port     = 3000
//     protocol = "HTTP"
//   }
// }

// resource "aws_lb_target_group_attachment" "tf-attach-1" {
//   target_group_arn = aws_lb_target_group.jenk-lb.id
//   target_id        = aws_instance.web-app.*.id
//   port             = 3000
// }




// resource "aws_lb_listener" "jk-listener" {
//   load_balancer_arn = aws_lb.jenk-lb.id
//   port              = 3000
//   protocol          = "HTTP"

//   default_action {
//     target_group_arn = aws_lb_target_group.jenk-lb.id
//     type             = "forward"
    

//   }
// }

// # Security Group for ALB
// resource "aws_security_group" "jenk-lb-sg" {
//     name = "jenk-lb-sg"
//     description = "allow HTTPS to Load Balancer (ALB)"
//     vpc_id = var.vpc_id
//     ingress {
//         from_port = 3000
//         to_port = 3000
//         protocol = "tcp"
//         cidr_blocks = ["0.0.0.0/0"]

//     }
//     egress {
//     from_port   = 0
//     to_port     = 0
//     protocol    = "-1"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//     tags = {
//         Name = "jenk-lb-sg"
//     }
// }
