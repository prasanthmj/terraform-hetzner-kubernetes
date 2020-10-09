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
  ansible_playbook_path="../ansible/site.yaml"
}

module "rke_cluster"{
  source = "../modules/rke-cluster"
  nodes = module.hcloud.nodes
  ssh_key_path = var.ssh_key_path
}




