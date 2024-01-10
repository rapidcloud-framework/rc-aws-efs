resource "aws_efs_file_system" "efs" {
  encrypted = var.encrypted == "true" ? true : false
  tags      = merge(local.rc_tags, var.tags)
  # kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != "" ? [var.transition_to_ia] : []
    content {
      transition_to_ia = try(var.transition_to_ia, null)
    }
  }

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_primary != "" ? [var.transition_to_primary] : []
    content {
      transition_to_primary_storage_class = try(var.transition_to_primary, null)
    }
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "efs" {
  name_prefix = local.fs_name
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  tags = merge(local.rc_tags, var.tags)
}

resource "aws_efs_mount_target" "efs" {
  for_each        = var.subnet_ids
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_backup_policy" "efs" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = var.enable_backups == "true" ? "ENABLED" : "DISABLED"
  }
}
