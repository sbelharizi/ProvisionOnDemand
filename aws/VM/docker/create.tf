//TERRAFORM CREATE FILE FOR AWS DOCKER

//variable "POD_AWS_PROJECT" {}
variable "POD_AWS_REGION" {}
variable "POD_AWS_VM_TYPE" {}
variable "POD_AWS_SHARED_CREDIDENTIAL_PATH" {}
variable "POD_AWS_NB_INSTANCE" {}
variable "POD_AWS_SSH_PRIVATE_KEY" {}
variable "POD_AWS_SSH_KEY_NAME" {}
variable "POD_AWS_USER" {}


provider "aws" {
  shared_credentials_file = "${file("${var.POD_AWS_SHARED_CREDIDENTIAL_PATH}")}"
  region     =  "${var.POD_AWS_REGION}"

}


//Debut de la configuration reseau. On utilise le reseau VPC par defaut 
//Ensuite on cree les groupes de secu pour les regles Jenkins

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "aws_security_group" "tf_www_jk_security_group" {
  name        = "tf_www_jk_security_group"
  description = "Allow http, https, jenkins ports and all outbound traffic"
  vpc_id	  = "${data.aws_vpc.default.id}"

}


resource "aws_security_group_rule" "allow_ssh_inbound" {
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_www_jk_security_group.id}"
}


resource "aws_security_group_rule" "allow_http_inbound" {
  type        = "ingress"
  from_port   = "8080"
  to_port     = "8080"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_www_jk_security_group.id}"
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_www_jk_security_group.id}"
}

resource "aws_security_group_rule" "allow_50000_inbound" {
  type        = "ingress"
  from_port   = "50000"
  to_port     = "50000"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_www_jk_security_group.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_www_jk_security_group.id}"
}


// fin de la conf reseau
//debut de la conf de l'instance


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


resource "aws_instance" "web" {
  
count = "${var.POD_AWS_NB_INSTANCE}"


  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.POD_AWS_VM_TYPE}"
  key_name = "${var.POD_AWS_SSH_KEY_NAME}"
  //public_key = "${file("${var.POD_AWS_SSH_PRIVATE_KEY}")}"
  
 security_groups = [
  	"tf_www_jk_security_group"
 ]

  tags {
    Name = "tf-docker-${count.index}"
  }


// Fin de la conf de l'instance, debut des actions du startup script

 connection {
    type = "ssh"
    user = "${var.POD_AWS_USER}"

    private_key = "${file("${var.POD_AWS_SSH_PRIVATE_KEY}")}"
    agent       = false
	timeout = "30s"
}

  provisioner "remote-exec" {
    inline = [
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo usermod -aG docker `echo $USER`",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
	  "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo docker run -d -p 80:80 nginx"
    ]
}


}


output "public_ip" {
value = "${join("|", aws_instance.web.*.public_ip)}"
}







