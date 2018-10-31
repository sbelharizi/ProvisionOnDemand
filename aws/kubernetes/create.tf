//TERRAFORM CREATE FILE FOR AWS DOCKER

//variable "POD_AWS_PROJECT" {}
variable "POD_AWS_REGION" {}
variable "POD_AWS_VM_TYPE" {}
variable "POD_AWS_SHARED_CREDIDENTIAL_PATH" {}
variable "POD_COMMON_NB_INSTANCE" {}
variable "POD_COMMON_PRIV_KEY" {}
variable "POD_AWS_SSH_KEY_NAME" {}
variable "POD_COMMON_USER" {
  default = "ubuntu"
}

variable "POD_AWS_EKS_ARN_ROLE" {}


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


data "aws_subnet_ids" "example" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_subnet" "example" {
  count = "${length(data.aws_subnet_ids.example.ids)}"
  id = "${data.aws_subnet_ids.example.ids[count.index]}"
}

resource "aws_eks_cluster" "demo_cluster" {
  name            = "tf-eks-cluster-${count.index}"
  role_arn        = "${var.POD_AWS_EKS_ARN_ROLE}"

  vpc_config {
    subnet_ids         = ["${data.aws_subnet_ids.example.ids}"]
  }


}




//output "endpoint" {
//value = "${aws_eks_cluster.example.certificate_authority.0.data}"
//}
