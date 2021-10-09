output "jen_vpc_id" {
    value = aws_vpc.jenkins.id
}

output "jen_subnet_id" {
    value = aws_subnet.public_subnet.*.id
}

// output "jen_ec2_id" {
//     value = aws_instance.web-app.*.id
// }

