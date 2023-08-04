variable "name" {
  type = string
  description = "The name prefix for the resource."
}

/*variable "task_container_port" {
  description = "The port number on the container that is bound to the user-specified or automatically assigned host port"
  type        = number
  default     = 80
}

variable "task_host_port" {
  description = "The port number on the container instance to reserve for your container."
  type        = number
  default     = 80
}*/

variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task."
  default     = 256
  type        = number
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the task."
  default     = 512
  type        = number
}