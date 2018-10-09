



variable "POD_GCP_PROJECT" {}
variable "POD_GCP_REGION" {}
variable "POD_GCP_ZONE" {}

variable "POD_GCP_VM_TYPE" {}




// Configure the Google Cloud provider
provider "google" {
	credentials	= "${file("~/Documents/AuthFile/production-auth.json")}"
	project	= "${var.POD_GCP_PROJECT}"
	region	= "${var.POD_GCP_REGION}"
}



resource "google_compute_instance" "docker" {
  count = 3

  name         = "tf-docker-${count.index}"
  machine_type = "${var.POD_GCP_VM_TYPE}"
  zone         = "${var.POD_GCP_REGION}"
  tags         = ["docker-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160602"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  metadata {
    ssh-keys = "root:${file("~/.ssh/google_compute_engine.pub")}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("~/.ssh/google_compute_engine")}"
      agent       = false
    }

    inline = [
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo usermod -aG docker `echo $USER`",
      "sudo docker run -d -p 80:80 nginx"
    ]
  }

  service_account {
    scopes = [
    "https://www.googleapis.com/auth/compute.readonly"
    ]
  }
}

resource "google_compute_firewall" "default" {
  name    = "tf-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-node"]
}