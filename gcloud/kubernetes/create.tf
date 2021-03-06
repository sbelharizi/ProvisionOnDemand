
variable "POD_GCP_PROJECT" {}
variable "POD_GCP_REGION" {}
variable "POD_GCP_ZONE" {}
variable "POD_GCP_VM_TYPE" {}
variable "POD_GCP_CREDIDENTIAL_PATH" {}
variable "POD_COMMON_PUB_KEY" {}
variable "POD_COMMON_PRIV_KEY" {}
variable "POD_COMMON_NB_INSTANCE" {}
variable "POD_COMMON_USER" {
  default = "root"
}



// Configure the Google Cloud provider
provider "google" {
	credentials	= "${file("${var.POD_GCP_CREDIDENTIAL_PATH}")}"
	project	= "${var.POD_GCP_PROJECT}"
	region	= "${var.POD_GCP_REGION}"
}





resource "google_container_cluster" "primary" {
  name      = "${var.POD_GCP_PROJECT}"
  zone      = "${var.POD_GCP_REGION}"
  initial_node_count  = "3"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}




// resource "google_compute_instance" "docker" {
//   count = "${var.POD_COMMON_NB_INSTANCE}"

//   name         = "tf-docker-${count.index}"
//   machine_type = "${var.POD_GCP_VM_TYPE}"
//   zone         = "${var.POD_GCP_REGION}"
//   tags         = ["docker-node"]

//   boot_disk {
//     initialize_params {
//       image = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160602"
//     }
//   }

//   network_interface {
//     network = "default"

//     access_config {
//       # Ephemeral
//     }
//   }

//   metadata {
//     ssh-keys = "root:${file("${var.POD_COMMON_PUB_KEY}")}"
//   }

//   provisioner "remote-exec" {
//     connection {
//       type        = "ssh"
//       user        = "${var.POD_COMMON_USER}"
//       private_key = "${file("${var.POD_COMMON_PRIV_KEY}")}"
//       agent       = false
//     }

//     inline = [
//       "sudo curl -sSL https://get.docker.com/ | sh",
//       "sudo usermod -aG docker `echo $USER`",
// 			"sudo curl -L \"https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
// 			"sudo chmod +x /usr/local/bin/docker-compose",
//       "sudo docker run -d -p 80:80 nginx"
//     ]
//   }

//   service_account {
//     scopes = [
//     "https://www.googleapis.com/auth/compute.readonly"
//     ]
//   }
// }

// resource "google_compute_firewall" "default" {
//   name    = "tf-www-firewall"
//   network = "default"

//   allow {
//     protocol = "tcp"
//     ports    = ["80","8080"]
//   }

//   source_ranges = ["0.0.0.0/0"]
//   target_tags   = ["docker-node"]
// }



// output "external_ip" {
//   value = "${join("|", google_compute_instance.docker.*.network_interface.0.access_config.0.assigned_nat_ip)}"
// }
