variable "region" {
    default = "us-east-1"
}

variable "vpc_id" {
    type = string
} 

variable "subnet_id" {
    type = list(string)

}

variable "cidr_block" {
    type = string
    default = "172.16.0.0/16"
}

variable "subnet_cidr" {
    type = list(string)
}

variable "ami" {
    default = "ami-087c17d1fe0178315"
}

variable "availability_zones" {
    type = list(string)

}

variable "key_name" {
    default = "A4L"
}

variable "ec2_id" {
    type = list(string)
}