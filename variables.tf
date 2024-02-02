variable "project_tags" {
  type        = map(string)
  description = "Tags used for aws tutorial"
  default = {
    project = "aws-terraform-test"
  }
}

variable "public_ip" {
  type        = string
  description = "45.83.216.17"
  default     = "0.0.0.0/0"
}

