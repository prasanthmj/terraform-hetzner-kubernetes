
resource "hcloud_ssh_key" "ssh" {
  name       = "${var.cluster_name}-key"
  public_key = file("${var.ssh_key_path}.pub")
}

resource "hcloud_network" "private_net" {
  name     = var.private_network_name
  ip_range = var.private_ip_range
}

resource "hcloud_network_subnet" "private_subnet" {
  network_id   = hcloud_network.private_net.id
  type         = "server"
  network_zone = var.private_network_zone
  ip_range     = var.private_ip_range
}

resource "hcloud_server" "cloud_nodes" {
  for_each = var.nodes

  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = var.hcloud_location
  ssh_keys    = [hcloud_ssh_key.ssh.name]
  
  provisioner "remote-exec" {
    inline = ["sleep 0"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_key_path)
    }
  }
    
  // Ansible Provisioner
  provisioner "ansible" {
    ansible_ssh_settings {
      insecure_no_strict_host_key_checking = true
      connect_timeout_seconds = 60
      connection_attempts = 10
    }

    plays {
      enabled = var.ansible_settings.playbook_path != "" ? true : false
      
      verbose = true
      
      playbook {
        file_path = var.ansible_settings.playbook_path
      }

      extra_vars = {
        cluster_name = var.cluster_name
        server_name  = each.value.name
        ansible_user = "root"
        deploy_user_name = var.ansible_settings.deploy_username
        deploy_user_key = file("${var.ansible_settings.deploy_user_key_path}.pub")
      }

    }

    connection {
      host = self.ipv4_address
      type = "ssh"
      user = "root"
      timeout="10m"
      private_key = file(var.ssh_key_path)
    }
  }
  //Ansible Provisioner end
  
}

resource "hcloud_server_network" "server_network" {
  for_each = var.nodes

  network_id = hcloud_network.private_net.id
  server_id  = hcloud_server.cloud_nodes[each.key].id
  ip         = each.value.private_ip
}
