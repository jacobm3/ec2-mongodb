variable "vpc_id" { type = string }
variable "hostname" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }
variable "admin_cidr_blocks" { type = list(string) }
variable "mongo_password" { type = string }