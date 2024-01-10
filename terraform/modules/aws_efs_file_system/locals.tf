locals {
  rc_tags = {
    Name     = "${var.profile}-${var.fs_name}"
    env      = var.env
    profile  = var.profile
    author   = "rapid-cloud"
    fqn      = var.fqn
    cmd_id   = var.cmd_id
    workload = var.workload
  }
  fs_name    = "${var.profile}-${var.fs_name}"
  subnet_ids = [for subnet, id in var.subnet_ids : id]
}
