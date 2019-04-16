variable "auth_url" {
  type    = "list"
  default   = ["https://keystone.openstack.eq.hostnetbv.nl:5000/v3"]
}

variable "image" {
  type    = "list"
  default   = ["centos-7-1809","ubuntu-18.04"]
}

variable "flavor" {
  type    = "list"
  default   = ["VPS-2CPU-2048MiB-125000kB"]
}

variable "network" {
  type    = "list"
  default   = ["provider-eq-04"]
}

variable "ottw" {
  type    = "list"
  default   = ["prom_poc", "Prometheus Proof of Concept security group"]
}

variable "ottw_rule_1" {
  type    = "list"
  default   = ["ingress", "IPv4", "tcp", 1, 65535, "0.0.0.0/0"]
}

variable "bastion" {
  type    = "list"
  default   = ["10.0.0.0/24"]
}

variable "databaseserver" {
  type    = "list"
  default   = ["10.0.1.0/24"]
}

variable "webserver" {
  type    = "list"
  default   = ["10.0.2.0/24"]
}
