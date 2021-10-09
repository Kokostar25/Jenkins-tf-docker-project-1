
resource "aws_vpc" "jenkins" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "jenkins"
  }
}

resource "aws_subnet" "public_subnet" {
  count     =   length(var.subnet_cidr)  
  vpc_id     = var.vpc_id
  cidr_block = element(var.subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "public_subnet-${element(var.availability_zones, count.index)}"
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "gw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
      cidr_block = "0.0.0.0/0"

      gateway_id = aws_internet_gateway.gw.id
    }
}
    
resource "aws_route_table_association" "rta" {
  count          =  length(var.subnet_cidr) 
  subnet_id      = var.subnet_id[count.index]
  route_table_id = aws_route_table.rt.id
}





