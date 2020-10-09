## Create a project
Inside project create an API token
Set the env variable to be the token
export HCLOUD_TOKEN=token

## Using provisioner is not recommended 
Although this project uses ansible provisioner, that is not the recommended way to init the server. 
The recommended way is to use Packer.io to create image and create nodes using the image


## Links
* [Terraform language reference](https://www.terraform.io/docs/configuration/index.html)
* [terraform-provider-rke examples](https://github.com/rancher/terraform-provider-rke/tree/master/examples)

