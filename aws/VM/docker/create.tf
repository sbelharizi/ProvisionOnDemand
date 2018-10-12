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
  //count = "${var.POD_AWS_NB_INSTANCE}"
  
count = "${var.POD_AWS_NB_INSTANCE}"


  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.POD_AWS_VM_TYPE}"
  key_name = "${var.POD_AWS_SSH_KEY_NAME}"
  //public_key = "${file("${var.POD_AWS_SSH_PRIVATE_KEY}")}"
  
  security_groups = [
  	"MyWebDMZ"
  ]

  tags {
    Name = "tf-docker-${count.index}"
  }


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
      "sudo docker run -d -p 80:80 nginx"
    ]
}


}


output "public_ip" {
value = "${join("|", aws_instance.web.*.public_ip)}"
}







