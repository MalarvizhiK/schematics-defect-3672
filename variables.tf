variable "region" {
  default     = "us-south"
  description = "The VPC Region that you want your VPC, networks and the F5 virtual server to be provisioned in. To list available regions, run `ibmcloud is regions`."
}

variable "generation" {
  default     = 2
  description = "The VPC Generation to target. Valid values are 2 or 1."
}

variable "zone" {
  default     = "us-south-1"
  description = "The zone to use. If unspecified, the us-south-1 is used."
}

variable "resource_group" {
  default     = "Default"
  description = "The resource group to use. If unspecified, the account's default resource group is used."
}

variable "vpc_id" {
  default     = ""
  description = "The vpc id to use." 
}

variable "ssh_key" {
  default     = ""
  description = "The ssh key to use. If unspecified, 'my-ssh-key' is used."
}

variable "private_ssh_key" {
  default     = "--BEGIN--"
  description = "The private ssh key to use."
}

variable "failover_function_subnet_id" {
  default     = ""
  description = "subnet1 ipv4 cidr block."
}
