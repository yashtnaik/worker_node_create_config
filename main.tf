provider "aws" {
    access_key = ""
    secret_key = ""
    region = "ap-south-1"
}

resource "aws_instance" "terraform-instance" {
    ami= var.ami
    instance_type = var.instance_type
    key_name = var.key_name

    connection {
      type = "ssh"
      private_key = file("key/yashtnaik-instance-3.pem")
      user = "ubuntu"
      agent = false
      host = self.public_ip
    }

    provisioner "file" {
      source      = "k8s_installer.sh"
      destination = "/tmp/k8s_installer.sh"
  }

    provisioner "remote-exec" {
        inline = [ "sudo apt update -y",
         "export DEBIAN_FRONTEND=noninteractive",
         "sudo mv /tmp/k8s_installer.sh /home/k8s_installer.sh",
         "sudo chmod +x /home/k8s_installer.sh", 
         "sudo bash /home/k8s_installer.sh ${var.node_type}" ]

    }

    tags = {
      Name = var.node_tag
    }

}


