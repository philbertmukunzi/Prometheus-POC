provider "openstack" {
  auth_url = "${var.auth_url.[0]}"
}

data "openstack_images_image_v2" "image" {
  name = "${var.image.[0]}"
}

data "openstack_compute_flavor_v2" "flavor" {
  name = "${var.flavor.[0]}"
}

data "openstack_networking_network_v2" "network" {
  name = "${var.network.[0]}"
}

resource "openstack_networking_secgroup_v2" "ottw" {
  name        = "${var.ottw.[0]}"
  description = "${var.ottw.[1]}"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port = -1
    to_port = -1
    ip_protocol = "icmp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "prometheus" {
  name  = "${format("prom%02d", count.index + 1)}.poc"
  count = 1
  flavor_id         = "${data.openstack_compute_flavor_v2.flavor.id}"
  security_groups   = ["${openstack_networking_secgroup_v2.ottw.name}"]

  block_device {
    uuid                  = "${data.openstack_images_image_v2.image.id}"
    source_type           = "image"
    volume_size           = "20"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = "true"
  }

  network {
    uuid = "${data.openstack_networking_network_v2.network.id}"
  }
}

resource "openstack_compute_instance_v2" "webserver" {
  name  = "${format("webserver%02d", count.index + 1)}.webserver"
  count = 1
  flavor_id         = "${data.openstack_compute_flavor_v2.flavor.id}"
  security_groups   = ["${openstack_networking_secgroup_v2.ottw.name}"]

  block_device {
    uuid                  = "${data.openstack_images_image_v2.image.id}"
    source_type           = "image"
    volume_size           = "20"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = "true"
  }

  network {
    uuid = "${data.openstack_networking_network_v2.network.id}"
  }
}
