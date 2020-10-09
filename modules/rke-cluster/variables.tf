
variable "nodes" {
    type = map(object({
        ipv4_address = string
        internal_ip  = string
    }))
}


# Required configuration
variable "ssh_key_path" {
    type=string
}
