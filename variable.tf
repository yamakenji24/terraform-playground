variable "region" {
  default = "ap-northeast-1"
}

variable "role_arn" {
  description = "Role ARN as terraform executor"
  type        = string
  default     = "arn:aws:iam::237505168978:user/kenji-test"
}
