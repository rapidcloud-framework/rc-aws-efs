
variable "env" {}
variable "profile" {}
variable "workload" {}
variable "fqn" {}
variable "cmd_id" { default = "" }
variable "encrypted" {}

variable "fs_name" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "tags" { default = {} }
variable "transition_to_ia" {}
variable "transition_to_primary" {}
variable "enable_backups" {}
variable "performance_mode" {}
variable "throughput_mode" {}
variable "provisioned_throughput_in_mibps" { default = 0 }

