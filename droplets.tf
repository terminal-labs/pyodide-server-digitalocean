data "digitalocean_ssh_key" "ssh_key" {
  name = "digitalocean.pem"
}

resource "local_file" "deploy_ssh_key" {
  filename = "/tmp/id_rsa"
  content  = var.private_key
  file_permission = 600
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = data.external.droplet_name.result.name
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ssh_key.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${var.private_key}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt -y upgrade",
    ]
  }
}
