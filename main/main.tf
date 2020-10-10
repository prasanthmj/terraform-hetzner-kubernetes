terraform {
  required_version = ">= 0.13"
}

provider "hcloud" {
}
provider "rke" {
}

module "hcloud" {
  source = "../modules/hcloud"

  nodes  = var.nodes
  cluster_name = var.cluster_name
  ssh_key_path = var.ssh_key_path
  //ansible_playbook_path="../ansible/site.yaml"
  ansible_settings = {
    playbook_path = "../ansible/site.yaml"
    deploy_username = var.deploy_user.username
    deploy_user_key_path = var.deploy_user.ssh_key_path
  }
}

module "rke_cluster"{
  source = "../modules/rke-cluster"
  nodes = module.hcloud.nodes
  ssh_login = var.deploy_user
}




