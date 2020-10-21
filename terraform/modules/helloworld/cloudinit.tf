# Template for the cloud-init's cloud-config:
data "template_file" "cloudinit" {
  template = "${data.template_cloudinit_config.template.rendered}"

  vars {
    environment       = "${var.environment}"
    apps              = "${var.application}"
    ansible_hosts_key = "ansible_hosts"
    bbdd_address      = "${var.bbdd_address}"
    access_key        = "${var.access_key}"
    secret_key        = "${var.secret_key}"
    region            = "${var.region}"
  }
}

# Multi-part cloudinit config:
data "template_cloudinit_config" "template" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${file("${path.module}/../common/cloudinit/cloud-init-config-template.yaml")}"
  }
}
