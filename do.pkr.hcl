# Set the version of PocketBase using the following Packer variable:
variable "version" {
  type             = string
  default          = "0.10.1"
}

source "digitalocean" "ubuntu-2204" {
  droplet_name     = "packer"
  image            = "ubuntu-22-04-x64"
  region           = "sfo3"
  size             = "s-1vcpu-1gb"
  snapshot_name    = "pocketbase-${var.version}"
  snapshot_regions = ["sfo3"]
  ssh_username     = "root"
  droplet_agent    = false
}

build {
  sources = ["source.digitalocean.ubuntu-2204"]

  provisioner "file" {
    destination = "/var/tmp"
    source      = "files/"
  }

  provisioner "shell" {
    environment_vars = [
      "PB_VERSION=${var.version}",
    ]
    scripts          = ["scripts/01_setup_machine.sh", "scripts/03_cleanup.sh", "scripts/04_img_check.sh"]
  }

}
