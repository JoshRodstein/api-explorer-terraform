/*
variable "aws_access_key_id"        { }
variable "aws_secret_access_key"    { }
*/

variable "region"                   { default = "us-east-2" }
variable "enable_eip"               { default = "false" }
variable "elastic_ip"               { }
variable "private_key"              { }
variable "instance_name"            { }
variable "instance_type"            { }
variable "key_name"                 { }
variable "security_group"           { }
variable "ami_id"                   { }
variable "env"                      { }
variable "user"                     { }
