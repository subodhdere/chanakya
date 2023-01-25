variable "repository_name" {
  description = "Name of repository to create"
  type        = string
  default     = "kasm-repo"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}