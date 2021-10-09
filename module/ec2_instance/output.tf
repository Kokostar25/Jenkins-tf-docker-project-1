output "jen_ec2_id" {
    value = aws_instance.web-app.*.id
}
