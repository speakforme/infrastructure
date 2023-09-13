variable "campaign-a-ip" {
  type    = "list"
  default = ["34.199.252.2"]
}

variable "campaign-domain" {
  default = "speakforme.in"
}

variable "campaign-env" {
  default = "production"
}

variable "campaign-a-domain" {
  default = "campaign.speakforme.in"
}

variable "postal-server-ip" {
  type    = "list"
  default = ["18.211.250.184"]
}

variable "storage-a-ip" {
  type    = "list"
  default = ["35.153.240.239"]
}

variable "speakforme-a-ip" {
  type    = "list"
  default = ["104.198.14.52"]
}

variable "beta-cname" {
  type    = "list"
  default = ["speakforme.github.io."]
}

variable "netlify-cname" {
  type    = "list"
  default = ["speakforme.netlify.com."]
}

variable "psrp-email-cname" {
  type    = "list"
  default = ["rp.postal.speakforme.in."]
}

variable "psrp-cname" {
  type    = "list"
  default = ["rp.postal.speakforme.in."]
}

variable "www-cname" {
  type    = "list"
  default = ["speakforme.netlify.com."]
}

variable "email-mx-record" {
  type    = "list"
  default = ["10 inbound-smtp.eu-west-1.amazonaws.com."]
}

variable "email-mx-name" {
  default = "email"
}

variable "routes-mx-record" {
  type    = "list"
  default = ["10 mx.postal.speakforme.in."]
}

variable "routes-mx-name" {
  default = "routes"
}

variable "speakforme-mx-name" {
  default = "speakforme.in"
}

variable "speakforme-mx-record" {
  type    = "list"
  default = ["10 mx.postal.speakforme.in."]
}

variable "infrastructure-bucket" {
  default = "speakforme-infrastructure"
}

variable "email-bucket" {
  default = "speakforme-emails"
}
