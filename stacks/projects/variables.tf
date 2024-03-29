
variable "projects" {
  type = list(string)
}

variable "default_apis" {
  type    = list(string)
  default = []
}

variable "additional_apis" {
  type    = map(list(string))
  default = {}
}

variable "folder" {
  type = string
}

variable "billing_account" {
  type = string
}
